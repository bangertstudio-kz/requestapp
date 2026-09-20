import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import_summary.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/import_row.dart';
import 'import_file.dart';

/// Считает, что изменится, сверяя строки файла с веткой-приёмником.
///
/// Сравнение по ветке, а не по всему справочнику: «Труба ⌀25» в ППР
/// и в металлопластике — разные материалы, и склеивать их нельзя.
CatalogImportSummary summarizeImport({
  required String fileName,
  required List<CatalogCategory> categories,
  required CatalogCategory? target,
  required List<ImportRow> rows,
  required ParsedImportFile parsed,
  required int rootless,
}) {
  final scope = target?.categories ?? categories;

  // Что уже лежит в каждой ветке приёмника, ключ — путь относительно него.
  final known = <String, Set<String>>{
    '': {
      for (final item in target?.items ?? const <CatalogItem>[])
        item.name.toLowerCase(),
    },
  };
  void walk(List<CatalogCategory> level, List<String> prefix) {
    for (final category in level) {
      final path = [...prefix, category.name];
      known[path.join(_pathKey)] = {
        for (final item in category.items) item.name.toLowerCase(),
      };
      walk(category.categories, path);
    }
  }

  walk(scope, const []);

  final created = <String>{};
  var added = 0;
  var updated = 0;

  for (final row in rows) {
    final key = row.path.join(_pathKey);
    if (known[key]?.contains(row.name.toLowerCase()) ?? false) {
      updated++;
    } else {
      added++;
    }
    // Ветка появится вместе со строкой — и все её недостающие предки.
    for (var depth = 1; depth <= row.path.length; depth++) {
      final branch = row.path.take(depth).join(_pathKey);
      if (!known.containsKey(branch)) created.add(branch);
    }
  }

  return CatalogImportSummary(
    fileName: fileName,
    targetPath: target == null ? const [] : categoryPath(categories, target),
    itemsAdded: added,
    itemsUpdated: updated,
    categoriesCreated: created.length,
    duplicatesRemoved: parsed.duplicatesRemoved,
    rowsTrimmed: parsed.rowsTrimmed,
    rowsSkipped: parsed.rowsSkipped + rootless,
    unknownUnits: parsed.unknownUnits,
  );
}

/// Ключ пути в служебных картах. Символ, которого не бывает в названии
/// категории, — иначе «А» + «Б/В» и «А/Б» + «В» стали бы одной веткой.
const _pathKey = '\u0000';

CatalogCategory? findCategoryById(List<CatalogCategory> categories, String id) {
  for (final category in categories) {
    if (category.id == id) return category;
    final found = findCategoryById(category.categories, id);
    if (found != null) return found;
  }
  return null;
}

/// Путь до категории-приёмника — для подписи «Куда» в отчёте.
List<String> categoryPath(
  List<CatalogCategory> categories,
  CatalogCategory target,
) {
  List<String>? search(List<CatalogCategory> level, List<String> prefix) {
    for (final category in level) {
      final path = [...prefix, category.name];
      if (category.id == target.id) return path;
      final found = search(category.categories, path);
      if (found != null) return found;
    }
    return null;
  }

  return search(categories, const []) ?? [target.name];
}
