import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Одна заявка по идентификатору.
///
/// Нужен даже когда заявку открыли из списка и модель уже есть: после правки
/// позиции экран обязан показать пересчитанную заявку, а не ту, что приехала
/// с предыдущего экрана.
class RequestDetailNotifier
    extends RequestNotifier<MaterialRequest, RequestParams> {
  RequestDetailNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(RequestParams params) =>
      _repository.byId(params.id);
}
