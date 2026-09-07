import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Создание пустой заявки в открытой папке.
class CreateRequestNotifier
    extends RequestNotifier<MaterialRequest, CreateRequestParams> {
  CreateRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(CreateRequestParams params) =>
      _repository.create(folderId: params.folderId);
}
