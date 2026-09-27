import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_export.dart';
import '../domain/entities/catalog_params.dart';

/// Выгрузка справочника или ветки в Excel.
class ExportCatalogNotifier
    extends RequestNotifier<CatalogExport, ExportCatalogParams> {
  ExportCatalogNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<CatalogExport> fetch(ExportCatalogParams params) =>
      _repository.exportCatalog(categoryId: params.categoryId);
}
