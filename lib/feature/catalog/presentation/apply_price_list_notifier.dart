import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Замена справочника разобранным прайсом. Возвращает число материалов.
class ApplyPriceListNotifier
    extends RequestNotifier<int, ApplyPriceListParams> {
  ApplyPriceListNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<int> fetch(ApplyPriceListParams params) =>
      _repository.applyPriceList(params.summary);
}
