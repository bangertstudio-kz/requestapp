import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_item.dart';

/// Все материалы дерева одним списком, с любой глубины.
///
/// Функция, а не поле сущности: плоский список нужен двум экранам из шести,
/// и хранить его рядом с деревом значило бы держать два представления одних
/// и тех же данных, которые надо не забывать синхронизировать.
List<CatalogItem> flattenItems(List<CatalogCategory> categories) => [
  for (final category in categories) ...[
    ...category.items,
    ...flattenItems(category.categories),
  ],
];

/// Категория с заданным идентификатором на любой глубине.
///
/// Обход, а не поиск по корневому списку: категорию открывают по ссылке,
/// и уровень, на котором она лежит, экрану заранее неизвестен.
CatalogCategory? findCategory(List<CatalogCategory> categories, String id) {
  for (final category in categories) {
    if (category.id == id) return category;
    final found = findCategory(category.categories, id);
    if (found != null) return found;
  }
  return null;
}

/// Все категории дерева плоским списком — для выбора родителя в форме.
List<CatalogCategory> flattenCategories(List<CatalogCategory> categories) => [
  for (final category in categories) ...[
    category,
    ...flattenCategories(category.categories),
  ],
];
