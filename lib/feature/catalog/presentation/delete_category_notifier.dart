import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Удаление категории вместе с её подкатегориями и материалами.
class DeleteCategoryNotifier
    extends RequestNotifier<String, CatalogEntryParams> {
  DeleteCategoryNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(CatalogEntryParams params) async {
    await _repository.deleteCategory(params.id);
    return params.id;
  }
}
