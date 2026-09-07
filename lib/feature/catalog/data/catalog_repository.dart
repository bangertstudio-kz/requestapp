import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import_summary.dart';
import '../domain/entities/catalog_material.dart';
import '../domain/entities/material_draft.dart';

/// Справочник материалов: дерево, поиск и правки.
abstract interface class CatalogRepository {
  /// Всё дерево целиком. 326 материалов помещаются в память и нужны сразу:
  /// экран подбора разворачивает ветки на месте, и догрузка листа по нажатию
  /// была бы спиннером там, где ожидался список.
  Future<List<CatalogCategory>> categories();

  /// Плоский поиск по названиям материалов во всём справочнике.
  Future<List<CatalogMaterial>> searchMaterials(String query);

  /// Создаёт или переименовывает категорию. `id == null` — создание.
  Future<void> saveCategory({String? id, required String name});

  Future<void> deleteCategory(String id);

  Future<void> saveSubcategory({
    String? id,
    required String categoryId,
    required String name,
  });

  Future<void> deleteSubcategory(String id);

  /// Создаёт, переименовывает или переносит материал в другую подкатегорию.
  Future<void> saveMaterial(MaterialDraft draft);

  Future<void> deleteMaterial(String id);

  /// Разбирает файл прайса и считает, что даст импорт. Справочник при этом
  /// не трогает: пользователь должен увидеть цифры до того, как согласится.
  Future<CatalogImportSummary> parsePriceList(String fileName);

  /// Заменяет справочник разобранным файлом. Возвращает число материалов.
  Future<int> applyPriceList(CatalogImportSummary summary);
}
