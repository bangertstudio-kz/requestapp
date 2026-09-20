import 'dart:io';

import '../../../core/domain/described_exception.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/item_draft.dart';
import '../domain/entities/item_unit.dart';
import 'catalog_repository.dart';
import 'import_file.dart';
import 'import_summary.dart';
import 'price_list_seed.dart';

/// Категория в памяти — то же, что строка таблицы.
typedef _Node = ({String id, String name, String? parentId});

/// Материал в памяти.
typedef _Leaf = ({String id, String name, ItemUnit unit, String categoryId});

/// Справочник в памяти, засеянный настоящим прайсом заказчика.
///
/// Не тестовая заглушка, а второй полноправный вход в приложение: по нему
/// проходится весь сценарий целиком — подбор, правка справочника, импорт.
/// Поэтому и данные настоящие: на «Материал 1 / Материал 2» экран подбора
/// выглядел бы удобным, а на 154 позициях ППР — уже нет.
///
/// Хранит плоские списки, а дерево собирает при чтении — как база. Держать
/// вложенную структуру и переносить в ней ветки значило бы писать второй,
/// непохожий алгоритм для тех же операций.
class MockCatalogRepository implements CatalogRepository {
  MockCatalogRepository() {
    _seed(priceListSeed(), null);
  }

  /// Задержка, за которую видно загрузку, но не успевает надоесть.
  static const Duration _latency = Duration(milliseconds: 220);

  final _nodes = <_Node>[];
  final _leaves = <_Leaf>[];
  int _nextId = 1;

  String _id(String prefix) => '$prefix-${_nextId++}';

  /// Идентификаторы берутся из прайса, а не выдаются заново: они позиционные
  /// и стабильные, и ссылка на материал остаётся валидной между запусками.
  /// Свои идентификаторы мок раздаёт только тому, что завели руками.
  void _seed(List<CatalogCategory> categories, String? parentId) {
    for (final category in categories) {
      _nodes.add((
        id: category.id,
        name: category.name,
        parentId: parentId,
      ));
      for (final item in category.items) {
        _leaves.add((
          id: item.id,
          name: item.name,
          unit: item.unit,
          categoryId: category.id,
        ));
      }
      _seed(category.categories, category.id);
    }
  }

  Future<T> _delayed<T>(T Function() compute) async {
    await Future<void>.delayed(_latency);
    return compute();
  }

  @override
  Future<List<CatalogCategory>> categories() => _delayed(() => _tree(null));

  List<CatalogCategory> _tree(String? parentId) => [
    for (final node in _nodes)
      if (node.parentId == parentId)
        CatalogCategory(
          id: node.id,
          name: node.name,
          parentId: node.parentId,
          categories: _tree(node.id),
          items: [
            for (final leaf in _leaves)
              if (leaf.categoryId == node.id) _item(leaf),
          ],
        ),
  ];

  CatalogItem _item(_Leaf leaf) => CatalogItem(
    id: leaf.id,
    name: leaf.name,
    unit: leaf.unit,
    path: _path(leaf.categoryId),
  );

  /// Названия категорий от корня, с защитой от петли: цикл в данных
  /// не должен превращаться в зависший экран.
  List<String> _path(String categoryId) {
    final names = <String>[];
    final seen = <String>{};
    String? cursor = categoryId;
    while (cursor != null && seen.add(cursor)) {
      final node = _nodes.where((item) => item.id == cursor).firstOrNull;
      if (node == null) break;
      names.insert(0, node.name);
      cursor = node.parentId;
    }
    return names;
  }

  @override
  Future<List<CatalogItem>> searchItems(String query) => _delayed(() {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const <CatalogItem>[];
    return [
      for (final leaf in _leaves)
        if (leaf.name.toLowerCase().contains(needle)) _item(leaf),
    ];
  });

  @override
  Future<void> saveCategory({
    String? id,
    required String name,
    required String? parentId,
  }) => _delayed(() {
    if (parentId != null && !_nodes.any((node) => node.id == parentId)) {
      throw const DescribedFailure('Категория не найдена.');
    }

    if (id == null) {
      _nodes.add((id: _id('c'), name: name, parentId: parentId));
      return;
    }

    final index = _nodes.indexWhere((node) => node.id == id);
    if (index < 0) throw const DescribedFailure('Категория не найдена.');
    // Категория внутри собственного потомка исчезает из дерева, оставаясь
    // в данных: `_tree` обходит от корня и до такой ветки не доходит.
    if (parentId == id || (parentId != null && _isDescendant(parentId, id))) {
      throw const DescribedFailure(
        'Категорию нельзя перенести внутрь самой себя.',
      );
    }
    _nodes[index] = (id: id, name: name, parentId: parentId);
  });

  bool _isDescendant(String candidate, String ancestor) {
    final seen = <String>{};
    String? cursor = candidate;
    while (cursor != null && seen.add(cursor)) {
      if (cursor == ancestor) return true;
      cursor = _nodes.where((node) => node.id == cursor).firstOrNull?.parentId;
    }
    return false;
  }

  @override
  Future<void> deleteCategory(String id) => _delayed(() {
    final doomed = <String>{id};
    // Поддерево целиком: у базы это делает каскад, здесь — обход, пока
    // находятся потомки.
    bool grew = true;
    while (grew) {
      grew = false;
      for (final node in _nodes) {
        final parentId = node.parentId;
        if (parentId != null &&
            doomed.contains(parentId) &&
            doomed.add(node.id)) {
          grew = true;
        }
      }
    }
    _nodes.removeWhere((node) => doomed.contains(node.id));
    _leaves.removeWhere((leaf) => doomed.contains(leaf.categoryId));
  });

  @override
  Future<void> saveItem(ItemDraft draft) => _delayed(() {
    if (!_nodes.any((node) => node.id == draft.categoryId)) {
      // Раньше здесь подставлялась пустая строка, и материал уезжал
      // в справочник с путём «Канализация → ». Молча испорченная запись
      // хуже отказа: её замечают через неделю в отправленной заявке.
      throw const DescribedFailure('Категория не найдена.');
    }

    final id = draft.id;
    final leaf = (
      id: id ?? _id('m'),
      name: draft.name,
      unit: draft.unit,
      categoryId: draft.categoryId,
    );

    if (id == null) {
      _leaves.add(leaf);
      return;
    }

    final index = _leaves.indexWhere((item) => item.id == id);
    if (index < 0) throw const DescribedFailure('Материал не найден.');
    // Правка на месте: иначе переименование «Труба ⌀40/250» уносит её
    // в конец списка из тринадцати труб, и человек, поправивший опечатку,
    // ищет запись заново.
    _leaves[index] = leaf;
  });

  @override
  Future<void> deleteItem(String id) =>
      _delayed(() => _leaves.removeWhere((leaf) => leaf.id == id));

  @override
  Future<CatalogImport> parseImport(
    String filePath, {
    String? categoryId,
  }) => _delayed(() {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw const DescribedFailure('Файл не найден. Выберите его заново.');
    }
    final parsed = parseImportFile(file.readAsBytesSync());

    final rows = categoryId == null
        ? [
            for (final row in parsed.rows)
              if (row.path.isNotEmpty) row,
          ]
        : parsed.rows;

    final categories = _tree(null);
    final target = categoryId == null
        ? null
        : findCategoryById(categories, categoryId);
    if (categoryId != null && target == null) {
      throw const DescribedFailure('Категория не найдена.');
    }

    return CatalogImport(
      summary: summarizeImport(
        fileName: file.uri.pathSegments.last,
        categories: categories,
        target: target,
        rows: rows,
        parsed: parsed,
        rootless: parsed.rows.length - rows.length,
      ),
      rows: rows,
      categoryId: categoryId,
    );
  });

  @override
  Future<int> applyImport(CatalogImport import) => _delayed(() {
    var written = 0;
    for (final row in import.rows) {
      var parentId = import.categoryId;
      for (final name in row.path) {
        final existing = _nodes
            .where((node) => node.name == name && node.parentId == parentId)
            .firstOrNull;
        if (existing != null) {
          parentId = existing.id;
          continue;
        }
        final id = _id('c');
        _nodes.add((id: id, name: name, parentId: parentId));
        parentId = id;
      }
      if (parentId == null) continue;

      final index = _leaves.indexWhere(
        (leaf) =>
            leaf.categoryId == parentId &&
            leaf.name.toLowerCase() == row.name.toLowerCase(),
      );
      final leaf = (
        id: index < 0 ? _id('m') : _leaves[index].id,
        name: row.name,
        unit: row.unit,
        categoryId: parentId,
      );
      if (index < 0) {
        _leaves.add(leaf);
      } else {
        _leaves[index] = leaf;
      }
      written++;
    }
    return written;
  });

}
