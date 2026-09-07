import '../../../core/presentation/request_notifier.dart';
import '../data/request_repository.dart';
import '../domain/entities/request_folder.dart';
import '../domain/entities/requests_params.dart';

/// Создание папки для заявок.
class CreateFolderNotifier
    extends RequestNotifier<RequestFolder, CreateFolderParams> {
  CreateFolderNotifier(this._repository);

  final RequestRepository _repository;

  @override
  Future<RequestFolder> fetch(CreateFolderParams params) =>
      _repository.createFolder(params.name);
}
