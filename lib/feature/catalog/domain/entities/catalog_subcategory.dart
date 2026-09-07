import 'catalog_material.dart';

/// Подкатегория справочника — второй уровень дерева.
class CatalogSubcategory {
  const CatalogSubcategory({
    required this.id,
    required this.name,
    required this.materials,
  });

  final String id;
  final String name;

  /// Материалы приходят вместе с подкатегорией: дерево раскрывается на месте,
  /// и догружать лист по нажатию — это спиннер там, где ожидался список.
  final List<CatalogMaterial> materials;
}
