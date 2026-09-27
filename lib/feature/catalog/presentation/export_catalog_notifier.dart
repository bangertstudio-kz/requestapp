import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Выгрузка справочника или ветки в Excel. Данные — путь к готовому файлу.
class ExportCatalogNotifier
    extends RequestNotifier<String, ExportCatalogParams> {
  ExportCatalogNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(ExportCatalogParams params) =>
      _repository.exportCatalog(categoryId: params.categoryId);
}
