import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/requests_params.dart';

/// Сохранение заявки на устройство: XML и PDF плюс статус «Сохранена».
///
/// Отдельно от отправки: сохранение кладёт файлы рядом, отправка их отдаёт.
/// Это разные обещания, и объединять их в «главное действие» можно только
/// на кнопке, а не в коде.
class SaveRequestNotifier
    extends RequestNotifier<MaterialRequest, RequestParams> {
  SaveRequestNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<MaterialRequest> fetch(RequestParams params) =>
      _repository.save(params.id);
}
