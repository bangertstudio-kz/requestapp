import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/request_document.dart';
import '../domain/entities/requests_params.dart';

/// Сборка файлов заявки перед отправкой.
///
/// Обычный `RequestNotifier`: экран предпросмотра ждёт файлы ровно так же,
/// как любой другой экран ждёт данные — с загрузкой и отказом. Отдельной
/// базы «как RequestNotifier, только про файлы» для этого не нужно.
class PrepareDocumentsNotifier
    extends RequestNotifier<List<RequestDocument>, SendRequestParams> {
  PrepareDocumentsNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<List<RequestDocument>> fetch(SendRequestParams params) =>
      _repository.prepare(params.id, params.format);
}
