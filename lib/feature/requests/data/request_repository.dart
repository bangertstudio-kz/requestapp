import '../domain/entities/material_request.dart';
import '../domain/entities/request_document.dart';
import '../domain/entities/request_folder.dart';
import '../domain/entities/request_list.dart';
import '../domain/entities/requests_params.dart';
import '../domain/entities/send_format.dart';

/// Заявки и папки, в которых они лежат.
abstract interface class RequestRepository {
  /// Заявки, прошедшие папку, фильтр и поиск, плюс общее число заявок.
  /// Отбор делает хранилище: поиск идёт в том числе по названиям
  /// материалов внутри заявки.
  Future<RequestList> list(RequestsParams params);

  /// Одна заявка. Бросает, если её нет: экран детали открыт по ссылке,
  /// и «пустая заявка вместо удалённой» была бы ложью.
  Future<MaterialRequest> byId(String id);

  /// Новая пустая заявка в статусе «Черновик».
  /// [folderId] — папка, открытая в момент создания.
  Future<MaterialRequest> create({String? folderId});

  /// Переименование, правка позиций, добавление и удаление материала.
  /// Возвращает заявку в «Черновик»: файлы на устройстве после правки
  /// больше не соответствуют содержимому.
  Future<MaterialRequest> update(MaterialRequest request);

  /// Переносит заявку в папку или, при `folderId == null`, из папок наружу.
  ///
  /// Не `update`: папка не входит в документ, и возвращать из-за неё
  /// сохранённую заявку в черновик значило бы требовать сохранить заново
  /// того, кто просто навёл порядок.
  Future<MaterialRequest> moveToFolder(String id, String? folderId);

  Future<void> delete(String id);

  /// Собирает файлы выбранных форматов и возвращает их.
  ///
  /// Статус не меняет: пока файлы не ушли, заявка не отправлена. Зовётся
  /// экраном предпросмотра — тем, который показывает их перед отправкой.
  Future<List<RequestDocument>> prepare(String id, SendFormat format);

  /// Сохраняет таблицу и PDF на устройство и переводит заявку в «Сохранена» —
  /// после успешной записи, а не до неё.
  Future<MaterialRequest> save(String id);

  /// Отмечает отправку. Зовётся после того, как системный лист сообщил,
  /// что файлы приняты: отметка по нажатию показала бы «Отправлена» на
  /// заявке, которую никто не получил.
  Future<MaterialRequest> send(String id, SendFormat format);

  Future<List<RequestFolder>> folders();

  Future<RequestFolder> createFolder(String name);
}
