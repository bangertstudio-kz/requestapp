import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Удаление материала из справочника.
class DeleteMaterialNotifier
    extends RequestNotifier<String, CatalogEntryParams> {
  DeleteMaterialNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(CatalogEntryParams params) async {
    await _repository.deleteMaterial(params.id);
    return params.id;
  }
}
