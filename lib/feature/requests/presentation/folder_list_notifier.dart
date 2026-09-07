import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/request_folder.dart';

/// Папки со счётчиками на главном экране.
///
/// Параметризован `Null`: у запроса нет аргументов, но класс параметров
/// заводить не за чем — фильтровать папки нечем.
class FolderListNotifier extends RequestNotifier<List<RequestFolder>, Null> {
  FolderListNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<List<RequestFolder>> fetch(Null params) => _repository.folders();
}
