import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Новый порядок материалов категории после перетаскивания.
class ReorderItemsNotifier extends RequestNotifier<String, ReorderItemsParams> {
  ReorderItemsNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(ReorderItemsParams params) async {
    await _repository.reorderItems(params.categoryId, params.itemIds);
    return params.categoryId;
  }
}
