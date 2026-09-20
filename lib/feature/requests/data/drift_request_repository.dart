import '../domain/entities/material_request.dart';
import '../domain/entities/request_folder.dart';
import '../domain/entities/request_list.dart';
import '../domain/entities/requests_params.dart';
import '../domain/entities/send_format.dart';
import '../domain/entities/request_document.dart';
import 'datasources/request_local_data_source.dart';
import 'request_documents.dart';
import 'request_repository.dart';

/// Заявки поверх локального хранилища.
///
/// Тонкий по составу, но не пустой: здесь живёт всё, что хранилищем не
/// является, — как называется новая заявка, что считать «сейчас» и что
/// означает «сохранить». Датасорс про это не знает и знать не должен.
class DriftRequestRepository implements RequestRepository {
  DriftRequestRepository(
    this._local, {
    RequestDocuments? documents,
    DateTime Function()? now,
  }) : documents = documents ?? FileRequestDocuments(),
       _now = now ?? DateTime.now;

  final RequestLocalDataSource _local;

  /// Сборка файлов отдельным собеседником: вид таблицы задаёт принимающая
  /// сторона, и репозиторий не должен меняться вместе с ним.
  final RequestDocuments documents;

  /// Часы отдельным полем: тест на «правка вернула заявку в черновик»
  /// не должен зависеть от того, в какую секунду его запустили.
  final DateTime Function() _now;

  @override
  Future<RequestList> list(RequestsParams params) => _local.list(params);

  @override
  Future<MaterialRequest> byId(String id) => _local.byId(id);

  @override
  Future<MaterialRequest> create({String? folderId}) {
    final createdAt = _now();
    return _local.create(
      folderId: folderId,
      name: 'Заявка от ${_formatDate(createdAt)}',
      createdAt: createdAt,
    );
  }

  @override
  Future<MaterialRequest> update(MaterialRequest request) =>
      _local.update(request);

  @override
  Future<MaterialRequest> moveToFolder(String id, String? folderId) =>
      _local.moveToFolder(id, folderId);

  @override
  Future<void> delete(String id) => _local.delete(id);

  @override
  Future<List<RequestDocument>> prepare(String id, SendFormat format) async =>
      documents.build(await _local.byId(id), format);

  @override
  Future<MaterialRequest> save(String id) async {
    final request = await _local.byId(id);
    // Сначала файлы, потом отметка. Обратный порядок оставил бы статус
    // «Сохранена» на заявке, файлов которой нет: место на диске кончается
    // тихо, а человек уходит со стройки, считая, что документ при нём.
    await documents.save(request);
    return _local.markSaved(id, _now());
  }

  @override
  Future<MaterialRequest> send(String id, SendFormat format) =>
      _local.markSent(id, format, _now());

  @override
  Future<List<RequestFolder>> folders() => _local.folders();

  @override
  Future<RequestFolder> createFolder(String name) => _local.createFolder(name);

  /// Дата в названии новой заявки: формат тот же, что показывает карточка,
  /// иначе название и подпись под ним выглядят из разных приложений.
  static String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.${date.year}';
}
