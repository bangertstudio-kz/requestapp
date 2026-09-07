import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Правка заявки: название, состав позиций, количество.
///
/// Одна операция на все правки, потому что у них один результат — заявка
/// возвращается в черновик. Разводить их по трём нотифаерам значило бы
/// трижды написать одно и то же обещание.
class UpdateRequestNotifier
    extends RequestNotifier<MaterialRequest, UpdateRequestParams> {
  UpdateRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(UpdateRequestParams params) =>
      _repository.update(params.request);
}
