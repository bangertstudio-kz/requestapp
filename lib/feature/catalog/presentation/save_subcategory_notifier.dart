import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Создание и переименование подкатегории.
class SaveSubcategoryNotifier
    extends RequestNotifier<String, SaveSubcategoryParams> {
  SaveSubcategoryNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<String> fetch(SaveSubcategoryParams params) async {
    await _repository.saveSubcategory(
      id: params.id,
      categoryId: params.categoryId,
      name: params.name,
    );
    return params.name;
  }
}
