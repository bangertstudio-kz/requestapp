import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_material.dart';
import '../domain/entities/catalog_search_params.dart';

/// Плоский поиск по материалам.
///
/// Отдельно от [CatalogNotifier]: поиск перезапускается на каждый ввод,
/// и подменять им дерево значило бы терять раскрытые ветки при каждой букве.
class MaterialSearchNotifier
    extends RequestNotifier<List<CatalogMaterial>, CatalogSearchParams> {
  MaterialSearchNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<List<CatalogMaterial>> fetch(CatalogSearchParams params) =>
      _repository.searchMaterials(params.query);
}
