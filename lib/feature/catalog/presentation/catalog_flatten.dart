import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_material.dart';

/// Все материалы дерева одним списком.
///
/// Функция, а не поле сущности: плоский список нужен двум экранам из шести,
/// и хранить его рядом с деревом значило бы держать два представления одних
/// и тех же данных, которые надо не забывать синхронизировать.
List<CatalogMaterial> flattenMaterials(List<CatalogCategory> categories) => [
  for (final category in categories)
    for (final subcategory in category.subcategories) ...subcategory.materials,
];
