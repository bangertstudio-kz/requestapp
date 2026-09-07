import 'catalog_subcategory.dart';

/// Категория справочника — верхний уровень дерева.
class CatalogCategory {
  const CatalogCategory({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  final String id;
  final String name;
  final List<CatalogSubcategory> subcategories;
}
