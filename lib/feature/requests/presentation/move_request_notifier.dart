import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Перенос заявки в другую папку.
///
/// Отдельно от [UpdateRequestNotifier], потому что отдельная операция:
/// правка возвращает заявку в черновик, перенос — нет.
class MoveRequestNotifier
    extends RequestNotifier<MaterialRequest, MoveRequestParams> {
  MoveRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(MoveRequestParams params) =>
      _repository.moveToFolder(params.id, params.folderId);
}
