import '../../../core/domain/described_exception.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import_summary.dart';
import '../domain/entities/catalog_material.dart';
import '../domain/entities/catalog_subcategory.dart';
import '../domain/entities/material_draft.dart';
import 'catalog_repository.dart';
import 'price_list_seed.dart';

/// Справочник в памяти, засеянный настоящим прайсом заказчика.
///
/// Не тестовая заглушка, а второй полноправный вход в приложение: по нему
/// проходится весь сценарий целиком — подбор, правка справочника, импорт.
/// Поэтому и данные настоящие: на «Материал 1 / Материал 2» экран подбора
/// выглядел бы удобным, а на 154 позициях ППР — уже нет.
class MockCatalogRepository implements CatalogRepository {
  MockCatalogRepository() : _categories = priceListSeed();

  /// Задержка, за которую видно загрузку, но не успевает надоесть.
  static const Duration _latency = Duration(milliseconds: 220);

  List<CatalogCategory> _categories;
  int _nextId = 1;

  String _id(String prefix) => '$prefix-${_nextId++}';

  Future<T> _delayed<T>(T Function() compute) async {
    await Future<void>.delayed(_latency);
    return compute();
  }

  @override
  Future<List<CatalogCategory>> categories() => _delayed(() => _categories);

  @override
  Future<List<CatalogMaterial>> searchMaterials(String query) => _delayed(() {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const <CatalogMaterial>[];
    return [
      for (final category in _categories)
        for (final subcategory in category.subcategories)
          for (final material in subcategory.materials)
            if (material.name.toLowerCase().contains(needle)) material,
    ];
  });

  @override
  Future<void> saveCategory({String? id, required String name}) => _delayed(() {
    if (id == null) {
      _categories = [
        ..._categories,
        CatalogCategory(id: _id('c'), name: name, subcategories: const []),
      ];
      return;
    }
    _categories = [
      for (final category in _categories)
        if (category.id == id)
          // Переименование категории переписывает и путь в материалах:
          // путь хранится строкой, чтобы карточка позиции показывала его
          // без обхода дерева, и рассинхрон здесь был бы виден сразу.
          CatalogCategory(
            id: category.id,
            name: name,
            subcategories: [
              for (final subcategory in category.subcategories)
                _renamePath(subcategory, categoryName: name),
            ],
          )
        else
          category,
    ];
  });

  @override
  Future<void> deleteCategory(String id) => _delayed(() {
    _categories = [
      for (final category in _categories)
        if (category.id != id) category,
    ];
  });

  @override
  Future<void> saveSubcategory({
    String? id,
    required String categoryId,
    required String name,
  }) => _delayed(() {
    _categories = [
      for (final category in _categories)
        if (category.id != categoryId)
          category
        else
          CatalogCategory(
            id: category.id,
            name: category.name,
            subcategories: id == null
                ? [
                    ...category.subcategories,
                    CatalogSubcategory(
                      id: _id('s'),
                      name: name,
                      materials: const [],
                    ),
                  ]
                : [
                    for (final subcategory in category.subcategories)
                      if (subcategory.id == id)
                        _renamePath(
                          subcategory,
                          categoryName: category.name,
                          subcategoryName: name,
                        )
                      else
                        subcategory,
                  ],
          ),
    ];
  });

  @override
  Future<void> deleteSubcategory(String id) => _delayed(() {
    _categories = [
      for (final category in _categories)
        CatalogCategory(
          id: category.id,
          name: category.name,
          subcategories: [
            for (final subcategory in category.subcategories)
              if (subcategory.id != id) subcategory,
          ],
        ),
    ];
  });

  @override
  Future<void> saveMaterial(MaterialDraft draft) => _delayed(() {
    final category = _categories
        .where((item) => item.id == draft.categoryId)
        .firstOrNull;
    if (category == null) {
      throw const DescribedFailure('Категория не найдена.');
    }
    final subcategory = category.subcategories
        .where((item) => item.id == draft.subcategoryId)
        .firstOrNull;
    if (subcategory == null) {
      // Раньше здесь подставлялась пустая строка, и материал уезжал
      // в справочник с путём «Канализация → ». Молча испорченная запись
      // хуже отказа: её замечают через неделю в отправленной заявке.
      throw const DescribedFailure('Подкатегория не найдена.');
    }

    final material = CatalogMaterial(
      id: draft.id ?? _id('m'),
      name: draft.name,
      unit: draft.unit,
      categoryName: category.name,
      subcategoryName: subcategory.name,
    );

    // Правка на месте, если материал уже лежит в целевой ветке: иначе
    // переименование «Труба ⌀40/250» уносит её в конец списка из тринадцати
    // труб, и человек, поправивший опечатку, ищет запись заново.
    final staysInPlace =
        draft.id != null &&
        subcategory.materials.any((item) => item.id == draft.id);

    final source = staysInPlace || draft.id == null
        ? _categories
        : _withoutMaterial(_categories, draft.id!);

    _categories = [
      for (final item in source)
        if (item.id != category.id)
          item
        else
          CatalogCategory(
            id: item.id,
            name: item.name,
            subcategories: [
              for (final sub in item.subcategories)
                if (sub.id != subcategory.id)
                  sub
                else
                  CatalogSubcategory(
                    id: sub.id,
                    name: sub.name,
                    materials: staysInPlace
                        ? [
                            for (final existing in sub.materials)
                              if (existing.id == material.id)
                                material
                              else
                                existing,
                          ]
                        : [...sub.materials, material],
                  ),
            ],
          ),
    ];
  });

  @override
  Future<void> deleteMaterial(String id) =>
      _delayed(() => _categories = _withoutMaterial(_categories, id));

  @override
  Future<CatalogImportSummary> parsePriceList(String fileName) => _delayed(() {
    if (!fileName.toLowerCase().endsWith('.xlsx')) {
      throw const DescribedFailure(
        'Нужен файл Excel (.xlsx) с листом «Материал».',
      );
    }
    // Цифры разбора настоящего прайса: шесть полных дублей строк в файле
    // есть на самом деле, и предупреждение о них — не выдумка мока.
    final seed = priceListSeed();
    return CatalogImportSummary(
      fileName: fileName,
      categories: seed.length,
      subcategories: seed.fold(0, (n, c) => n + c.subcategories.length),
      materials: seed.fold(
        0,
        (n, c) => n + c.subcategories.fold(0, (m, s) => m + s.materials.length),
      ),
      duplicatesRemoved: 6,
      rowsTrimmed: 14,
      rowsSkipped: 0,
      unknownUnits: const [],
    );
  });

  @override
  Future<int> applyPriceList(CatalogImportSummary summary) => _delayed(() {
    _categories = priceListSeed();
    return summary.materials;
  });

  static List<CatalogCategory> _withoutMaterial(
    List<CatalogCategory> categories,
    String materialId,
  ) => [
    for (final category in categories)
      CatalogCategory(
        id: category.id,
        name: category.name,
        subcategories: [
          for (final subcategory in category.subcategories)
            CatalogSubcategory(
              id: subcategory.id,
              name: subcategory.name,
              materials: [
                for (final material in subcategory.materials)
                  if (material.id != materialId) material,
              ],
            ),
        ],
      ),
  ];

  static CatalogSubcategory _renamePath(
    CatalogSubcategory subcategory, {
    required String categoryName,
    String? subcategoryName,
  }) => CatalogSubcategory(
    id: subcategory.id,
    name: subcategoryName ?? subcategory.name,
    materials: [
      for (final material in subcategory.materials)
        CatalogMaterial(
          id: material.id,
          name: material.name,
          unit: material.unit,
          categoryName: categoryName,
          subcategoryName: subcategoryName ?? subcategory.name,
        ),
    ],
  );
}
