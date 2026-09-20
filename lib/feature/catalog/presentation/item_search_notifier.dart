import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/catalog_search_params.dart';

/// Плоский поиск по материалам.
///
/// Отдельно от [CatalogNotifier]: поиск перезапускается на каждый ввод,
/// и подменять им дерево значило бы терять раскрытые ветки при каждой букве.
class ItemSearchNotifier
    extends RequestNotifier<List<CatalogItem>, CatalogSearchParams> {
  ItemSearchNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<List<CatalogItem>> fetch(CatalogSearchParams params) =>
      _repository.searchItems(params.query);
}
