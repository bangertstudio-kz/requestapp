import 'catalog_import_summary.dart';
import 'import_row.dart';

/// Разобранный файл вместе с отчётом о нём.
///
/// Строки едут рядом с отчётом, а не разбираются заново при подтверждении:
/// второй разбор того же файла может дать другой результат, если файл
/// успели тронуть, — а человек согласился на цифры, которые увидел.
class CatalogImport {
  const CatalogImport({
    required this.summary,
    required this.rows,
    required this.categoryId,
  });

  final CatalogImportSummary summary;
  final List<ImportRow> rows;

  /// Категория-приёмник. `null` — корень справочника.
  final String? categoryId;
}
