import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/request_list.dart';
import '../domain/entities/requests_params.dart';

/// Список заявок с учётом папки, фильтра и поиска.
///
/// Отбор уезжает в репозиторий вместе с параметрами: экран не фильтрует
/// список у себя, потому что поиск идёт и по позициям внутри заявок.
class RequestListNotifier extends RequestNotifier<RequestList, RequestsParams> {
  RequestListNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<RequestList> fetch(RequestsParams params) => _repository.list(params);
}
