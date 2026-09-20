import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/text_search.dart';
import '../../../../core/domain/described_exception.dart';
import '../../domain/entities/catalog_category.dart';
import '../../domain/entities/catalog_item.dart';
import '../../domain/entities/import_row.dart';
import '../../domain/entities/item_draft.dart';
import 'catalog_local_data_source.dart';
import 'unit_mapping.dart';

/// Справочник в SQLite через drift.
class DriftCatalogLocalDataSource implements CatalogLocalDataSource {
  const DriftCatalogLocalDataSource(this._db);

  final AppDatabase _db;

  @override
  Future<List<CatalogCategory>> categories() async {
    final tree = await _readTree();
    return [
      for (final row in tree.roots) tree.build(row),
    ];
  }

  @override
  Future<List<CatalogItem>> searchItems(String query) async {
    if (normalizedName(query).isEmpty) return const [];

    final rows =
        await (_db.select(_db.items)
              ..where(
                (i) => i.nameLower.like(
                  containsPattern(query),
                  escapeChar: likeEscapeChar,
                ),
              )
              ..orderBy([(i) => OrderingTerm(expression: i.id)]))
            .get();
    if (rows.isEmpty) return const [];

    // Путь собирается подъёмом по parent_id, а глубина заранее неизвестна,
    // поэтому категории читаются целиком одним запросом. Для шести корней
    // и полусотни веток это дешевле рекурсивного запроса на каждый материал.
    final tree = await _readTree();
    return [for (final row in rows) tree.item(row)];
  }

  @override
  Future<void> saveCategory({
    String? id,
    required String name,
    required String? parentId,
  }) async {
    final parent = parentId == null ? null : _categoryId(parentId);
    if (parent != null) await _requireCategory(parent);

    if (id == null) {
      await _db
          .into(_db.categories)
          .insert(
            CategoriesCompanion.insert(name: name, parentId: Value(parent)),
          );
      return;
    }

    final categoryId = _categoryId(id);
    await _requireNoCycle(categoryId, parent);

    final updated =
        await (_db.update(_db.categories)
              ..where((c) => c.id.equals(categoryId)))
            .write(
              CategoriesCompanion(
                name: Value(name),
                parentId: Value(parent),
                updatedAt: Value(DateTime.now()),
              ),
            );
    if (updated == 0) throw _categoryNotFound;
  }

  /// Категория не может оказаться внутри собственного потомка: такая ветка
  /// пропадает из дерева, оставаясь в базе, и найти её потом можно только
  /// запросом. Поднимаемся от выбранного родителя вверх и смотрим, не
  /// встретится ли сама категория.
  Future<void> _requireNoCycle(int id, int? parentId) async {
    if (parentId == null) return;
    if (parentId == id) throw _cycle;

    final parents = {
      for (final row in await _db.select(_db.categories).get())
        row.id: row.parentId,
    };
    for (var cursor = parents[parentId]; cursor != null;) {
      if (cursor == id) throw _cycle;
      cursor = parents[cursor];
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    // Поддерево и материалы уходят каскадом, а позиции заявок теряют
    // ссылку: `ON DELETE SET NULL` на `request_item.item_id`.
    await (_db.delete(_db.categories)
          ..where((c) => c.id.equals(_categoryId(id))))
        .go();
  }

  @override
  Future<void> saveItem(ItemDraft draft) async {
    final categoryId = _categoryId(draft.categoryId);
    await _requireCategory(categoryId);

    final id = draft.id;
    if (id == null) {
      await _db
          .into(_db.items)
          .insert(
            ItemsCompanion.insert(
              subcategoryId: categoryId,
              unitId: unitIdOf(draft.unit),
              name: draft.name,
              nameLower: normalizedName(draft.name),
            ),
          );
      return;
    }

    final updated =
        await (_db.update(_db.items)..where((i) => i.id.equals(_itemId(id))))
            .write(
              ItemsCompanion(
                subcategoryId: Value(categoryId),
                unitId: Value(unitIdOf(draft.unit)),
                name: Value(draft.name),
                nameLower: Value(normalizedName(draft.name)),
                updatedAt: Value(DateTime.now()),
              ),
            );
    if (updated == 0) throw _itemNotFound;
  }

  @override
  Future<void> deleteItem(String id) async {
    await (_db.delete(_db.items)..where((i) => i.id.equals(_itemId(id)))).go();
  }

  @override
  Future<int> replaceCatalog(List<CatalogCategory> categories) =>
      _db.transaction(() async {
        // Порядок важен: материалы уходят первыми, иначе каскад от категорий
        // сделает это сам, и посчитать записанное станет не с чем сверить.
        await _db.delete(_db.items).go();
        await _db.delete(_db.categories).go();

        var written = 0;
        Future<void> insert(CatalogCategory category, int? parentId) async {
          final id = await _db
              .into(_db.categories)
              .insert(
                CategoriesCompanion.insert(
                  name: category.name,
                  parentId: Value(parentId),
                ),
              );
          for (final item in category.items) {
            await _db
                .into(_db.items)
                .insert(
                  ItemsCompanion.insert(
                    subcategoryId: id,
                    unitId: unitIdOf(item.unit),
                    name: item.name,
                    nameLower: normalizedName(item.name),
                  ),
                );
            written++;
          }
          for (final child in category.categories) {
            await insert(child, id);
          }
        }

        for (final category in categories) {
          await insert(category, null);
        }
        return written;
      });


  @override
  Future<int> importItems(String? categoryId, List<ImportRow> rows) =>
      _db.transaction(() async {
        final root = categoryId == null ? null : _categoryId(categoryId);
        if (root != null) await _requireCategory(root);

        // Ветки заводятся по пути строки и запоминаются: в файле на триста
        // строк один и тот же путь встречается десятки раз, и создавать
        // категорию на каждую строку значило бы триста лишних запросов.
        final byPath = <String, int?>{'': root};
        var written = 0;

        for (final row in rows) {
          var parentId = root;
          final walked = <String>[];
          for (final name in row.path) {
            walked.add(name);
            final key = walked.join('\u0000');
            if (byPath.containsKey(key)) {
              parentId = byPath[key];
              continue;
            }
            parentId = await _categoryByName(name, parentId) ??
                await _db.into(_db.categories).insert(
                      CategoriesCompanion.insert(
                        name: name,
                        parentId: Value(parentId),
                      ),
                    );
            byPath[key] = parentId;
          }

          final existing = await _itemByName(row.name, parentId);
          if (existing == null) {
            await _db.into(_db.items).insert(
                  ItemsCompanion.insert(
                    subcategoryId: parentId!,
                    unitId: unitIdOf(row.unit),
                    name: row.name,
                    nameLower: normalizedName(row.name),
                  ),
                );
          } else {
            await (_db.update(_db.items)
                  ..where((i) => i.id.equals(existing)))
                .write(
                  ItemsCompanion(
                    unitId: Value(unitIdOf(row.unit)),
                    updatedAt: Value(DateTime.now()),
                  ),
                );
          }
          written++;
        }
        return written;
      });

  /// Категория с таким названием под тем же родителем, если она уже есть.
  Future<int?> _categoryByName(String name, int? parentId) async {
    final query = _db.select(_db.categories)
      ..where((c) => c.name.equals(name));
    if (parentId == null) {
      query.where((c) => c.parentId.isNull());
    } else {
      query.where((c) => c.parentId.equals(parentId));
    }
    return (await query.getSingleOrNull())?.id;
  }

  Future<int?> _itemByName(String name, int? categoryId) async {
    if (categoryId == null) return null;
    final row =
        await (_db.select(_db.items)
              ..where(
                (i) =>
                    i.subcategoryId.equals(categoryId) &
                    i.nameLower.equals(normalizedName(name)),
              ))
            .getSingleOrNull();
    return row?.id;
  }

  /// Дерево и материалы одним чтением.
  ///
  /// Порядок — по идентификатору, а не по имени: он повторяет порядок строк
  /// прайса, где типоразмеры идут по возрастанию. Сортировка по названию
  /// поставила бы «⌀100» перед «⌀40» — строки сравниваются посимвольно,
  /// и для человека, ищущего трубу, это случайный порядок.
  Future<_CategoryTree> _readTree() async {
    final categoryRows =
        await (_db.select(_db.categories)
              ..orderBy([(c) => OrderingTerm(expression: c.id)]))
            .get();
    final itemRows =
        await (_db.select(_db.items)
              ..orderBy([(i) => OrderingTerm(expression: i.id)]))
            .get();
    return _CategoryTree(categoryRows, itemRows);
  }

  Future<void> _requireCategory(int id) async {
    final row = await (_db.select(_db.categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw _categoryNotFound;
  }

  static const _categoryNotFound = DescribedFailure('Категория не найдена.');
  static const _itemNotFound = DescribedFailure('Материал не найден.');
  static const _cycle = DescribedFailure(
    'Категорию нельзя перенести внутрь самой себя.',
  );

  /// Нечисловой идентификатор — не `FormatException` в логах, а отказ
  /// с фразой: сюда приходят значения из маршрута, и опечатка в ссылке
  /// должна выглядеть как ненайденная запись, а не как падение.
  static int _categoryId(String id) =>
      int.tryParse(id) ?? (throw _categoryNotFound);

  static int _itemId(String id) => int.tryParse(id) ?? (throw _itemNotFound);
}

/// Прочитанное дерево: строки категорий и материалов, разложенные так,
/// чтобы собрать и ветку, и путь без повторных запросов.
class _CategoryTree {
  _CategoryTree(List<CategoryRow> categories, List<ItemRow> items) {
    for (final row in categories) {
      _byId[row.id] = row;
      final parentId = row.parentId;
      if (parentId == null) {
        roots.add(row);
      } else {
        (_children[parentId] ??= []).add(row);
      }
    }
    for (final row in items) {
      (_items[row.subcategoryId] ??= []).add(row);
    }
  }

  final roots = <CategoryRow>[];
  final _byId = <int, CategoryRow>{};
  final _children = <int, List<CategoryRow>>{};
  final _items = <int, List<ItemRow>>{};

  CatalogCategory build(CategoryRow row) => CatalogCategory(
    id: '${row.id}',
    name: row.name,
    parentId: row.parentId == null ? null : '${row.parentId}',
    categories: [
      for (final child in _children[row.id] ?? const <CategoryRow>[])
        build(child),
    ],
    items: [
      for (final item in _items[row.id] ?? const <ItemRow>[]) this.item(item),
    ],
  );

  CatalogItem item(ItemRow row) => CatalogItem(
    id: '${row.id}',
    name: row.name,
    unit: unitFromId(row.unitId),
    path: pathOf(row.subcategoryId),
  );

  /// Названия категорий от корня. Подъём по ссылкам с защитой от петли:
  /// цикл в базе не должен превращаться в зависший экран.
  List<String> pathOf(int categoryId) {
    final names = <String>[];
    final seen = <int>{};
    for (var cursor = _byId[categoryId]; cursor != null;) {
      if (!seen.add(cursor.id)) break;
      names.insert(0, cursor.name);
      final parentId = cursor.parentId;
      cursor = parentId == null ? null : _byId[parentId];
    }
    return names;
  }
}
