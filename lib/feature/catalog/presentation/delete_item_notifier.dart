import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Удаление материала из справочника.
class DeleteItemNotifier
    extends RequestNotifier<String, CatalogEntryParams> {
  DeleteItemNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(CatalogEntryParams params) async {
    await _repository.deleteItem(params.id);
    return params.id;
  }
}
