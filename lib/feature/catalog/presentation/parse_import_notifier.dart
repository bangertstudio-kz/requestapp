import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_import.dart';
import '../domain/entities/catalog_params.dart';

/// Разбор выбранного файла и отчёт о том, что даст импорт.
class ParseImportNotifier
    extends RequestNotifier<CatalogImport, ParseImportParams> {
  ParseImportNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<CatalogImport> fetch(ParseImportParams params) =>
      _repository.parseImport(params.filePath, categoryId: params.categoryId);
}
