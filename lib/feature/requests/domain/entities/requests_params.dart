import '../../../../core/domain/entities/params.dart';
import 'request_filter.dart';
import 'material_request.dart';
import 'send_format.dart';

/// Аргументы списка заявок: папка, фильтр по статусу и строка поиска.
///
/// Отбор — параметры запроса, а не фильтрация в памяти на экране: в списке
/// заявок ищут в том числе по названиям материалов внутри, и складывать
/// это в `build` значит перебирать все позиции всех заявок на каждый кадр.
class RequestsParams extends Params {
  const RequestsParams({
    this.folderId,
    this.filter = RequestFilter.all,
    this.query = '',
  });

  /// `null` — весь список, вне папок.
  final String? folderId;

  final RequestFilter filter;
  final String query;

  RequestsParams copyWith({
    String? folderId,
    bool resetFolder = false,
    RequestFilter? filter,
    String? query,
  }) => RequestsParams(
    folderId: resetFolder ? null : (folderId ?? this.folderId),
    filter: filter ?? this.filter,
    query: query ?? this.query,
  );
}

/// Одна заявка по идентификатору.
class RequestParams extends Params {
  const RequestParams(this.id);

  final String id;
}

/// Отправка заявки: что отправляем и в каком формате.
class SendRequestParams extends Params {
  const SendRequestParams({required this.id, required this.format});

  final String id;
  final SendFormat format;
}

/// Создание заявки. Папка — та, что открыта в момент нажатия: заявка,
/// созданная внутри «Котельных», должна там же и оказаться.
class CreateRequestParams extends Params {
  const CreateRequestParams({this.folderId});

  final String? folderId;
}

/// Правка заявки целиком: название и позиции. Одна операция, потому что
/// у неё один результат — заявка возвращается в черновик.
class UpdateRequestParams extends Params {
  const UpdateRequestParams(this.request);

  final MaterialRequest request;
}

class CreateFolderParams extends Params {
  const CreateFolderParams(this.name);

  final String name;
}
