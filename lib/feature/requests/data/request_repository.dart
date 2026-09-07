import '../domain/entities/material_request.dart';
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

  Future<void> delete(String id);

  /// Сохраняет XML и PDF на устройство и переводит заявку в «Сохранена».
  Future<MaterialRequest> save(String id);

  /// Отправляет заявку с вложением выбранного формата.
  Future<MaterialRequest> send(String id, SendFormat format);

  Future<List<RequestFolder>> folders();

  Future<RequestFolder> createFolder(String name);
}
