import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Создание и переименование категории.
class SaveCategoryNotifier extends RequestNotifier<String, SaveCategoryParams> {
  SaveCategoryNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(SaveCategoryParams params) async {
    await _repository.saveCategory(id: params.id, name: params.name);
    return params.name;
  }
}
