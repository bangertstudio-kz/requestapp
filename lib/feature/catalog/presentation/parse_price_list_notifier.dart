import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_import_summary.dart';
import '../domain/entities/catalog_params.dart';

/// Разбор файла прайса.
///
/// Отдельно от применения: разбор ничего не меняет, и пользователь должен
/// увидеть его результат раньше, чем согласится заменить справочник.
class ParsePriceListNotifier
    extends RequestNotifier<CatalogImportSummary, ParsePriceListParams> {
  ParsePriceListNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<CatalogImportSummary> fetch(ParsePriceListParams params) =>
      _repository.parsePriceList(params.fileName);
}
