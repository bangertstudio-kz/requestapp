import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Отправка заявки с вложением выбранного формата.
class SendRequestNotifier
    extends RequestNotifier<MaterialRequest, SendRequestParams> {
  SendRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(SendRequestParams params) =>
      _repository.send(params.id, params.format);
}
