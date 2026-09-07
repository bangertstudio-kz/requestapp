import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/requests_params.dart';

/// Удаление заявки.
///
/// Возвращает идентификатор удалённого, а не `void`: вызывающему нужно знать,
/// что именно исчезло, чтобы увести экран со страницы, которой больше нет.
class DeleteRequestNotifier extends RequestNotifier<String, RequestParams> {
  DeleteRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<String> fetch(RequestParams params) async {
    await _repository.delete(params.id);
    return params.id;
  }
}
