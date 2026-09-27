import '../../../core/domain/described_exception.dart';
import '../domain/entities/catalog_category.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/entities/catalog_import.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/item_draft.dart';
import 'catalog_repository.dart';
import 'catalog_xlsx.dart';
import 'datasources/catalog_local_data_source.dart';
import 'import_file.dart';
import 'import_summary.dart';

/// Справочник поверх локального хранилища.
///
/// Разбор файла остаётся здесь, а не в датасорсе: формат меняется
/// независимо от того, куда потом ляжет разобранное, и хранилище не должно
/// знать ни про Excel, ни про имя листа.
class DriftCatalogRepository implements CatalogRepository {
  const DriftCatalogRepository(this._local);

  final CatalogLocalDataSource _local;

  @override
  Future<List<CatalogCategory>> categories() => _local.categories();

  @override
  Future<List<CatalogItem>> searchItems(String query) =>
      _local.searchItems(query);

  @override
  Future<void> saveCategory({
    String? id,
    required String name,
    required String? parentId,
  }) => _local.saveCategory(id: id, name: name, parentId: parentId);

  @override
  Future<void> deleteCategory(String id) => _local.deleteCategory(id);

  @override
  Future<void> saveItem(ItemDraft draft) => _local.saveItem(draft);

  @override
  Future<void> deleteItem(String id) => _local.deleteItem(id);

  @override
  Future<void> reorderItems(String categoryId, List<String> itemIds) =>
      _local.reorderItems(categoryId, itemIds);

  @override
  Future<String> exportCatalog({String? categoryId}) async =>
      writeCatalogXlsx(
        await _local.categories(),
        categoryId: categoryId,
        directory: await getTemporaryDirectory(),
      );

  @override
  Future<CatalogImport> parseImport(
    String filePath, {
    String? categoryId,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw const DescribedFailure('Файл не найден. Выберите его заново.');
    }
    final parsed = parseImportFile(await file.readAsBytes());

    // В корне справочника материалу лежать негде — там только категории.
    // Строки без пути отсеиваются здесь, один раз: иначе отчёт и запись
    // считали бы по разным правилам и разошлись бы в числах.
    final rows = categoryId == null
        ? [
            for (final row in parsed.rows)
              if (row.path.isNotEmpty) row,
          ]
        : parsed.rows;
    final rootless = parsed.rows.length - rows.length;

    final categories = await _local.categories();
    final target = categoryId == null ? null : findCategoryById(categories, categoryId);
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
        rootless: rootless,
      ),
      rows: rows,
      categoryId: categoryId,
    );
  }

  @override
  Future<int> applyImport(CatalogImport import) =>
      _local.importItems(import.categoryId, import.rows);


}
