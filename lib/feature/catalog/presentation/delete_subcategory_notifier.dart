import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Удаление подкатегории вместе с её материалами.
class DeleteSubcategoryNotifier
    extends RequestNotifier<String, CatalogEntryParams> {
  DeleteSubcategoryNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(CatalogEntryParams params) async {
    await _repository.deleteSubcategory(params.id);
    return params.id;
  }
}
