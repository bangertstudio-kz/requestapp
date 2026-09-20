import '../../../core/presentation/request_notifier.dart';
import '../data/catalog_repository.dart';
import '../domain/entities/catalog_params.dart';

/// Запись разобранного файла в справочник. Возвращает число материалов.
class ApplyImportNotifier extends RequestNotifier<int, ApplyImportParams> {
  ApplyImportNotifier(this._repository);

  final CatalogRepository _repository;

  @override
  Future<int> fetch(ApplyImportParams params) =>
      _repository.applyImport(params.import);
}
