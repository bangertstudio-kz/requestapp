import '../../../core/domain/described_exception.dart';
import '../../catalog/domain/entities/material_unit.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_filter.dart';
import '../domain/entities/request_folder.dart';
import '../domain/entities/request_item.dart';
import '../domain/entities/request_list.dart';
import '../domain/entities/request_status.dart';
import '../domain/entities/requests_params.dart';
import '../domain/entities/send_format.dart';
import 'request_repository.dart';

/// Заявки в памяти. Второй полноправный вход в приложение: сценарий
/// «создать → добавить материал → сохранить → отправить → поправить»
/// проходится целиком, вместе с возвратом в черновик после правки.
class MockRequestRepository implements RequestRepository {
  MockRequestRepository();

  static const Duration _latency = Duration(milliseconds: 220);

  /// Дата, от которой считается «сегодня» в демо-данных. Фиксированная,
  /// чтобы скриншоты и тесты не менялись от запуска к запуску.
  static final DateTime _today = DateTime(2026, 9, 6);

  final List<({String id, String name})> _folders = [
    (id: 'f1', name: 'ЖК Северный'),
    (id: 'f2', name: 'Котельные'),
    (id: 'f3', name: 'Склад и расходники'),
  ];

  final List<MaterialRequest> _requests = [
    MaterialRequest(
      id: 'r1',
      name: 'ЖК Северный, стояки Б2',
      createdAt: DateTime(2026, 9, 4),
      status: RequestStatus.draft,
      folderId: 'f1',
      items: const [
        RequestItem(
          id: 'r1-1',
          name: 'Труба ⌀100/2000',
          categoryName: 'Канализация',
          subcategoryName: 'Труба',
          quantity: 24,
          unit: MaterialUnit.piece,
        ),
        RequestItem(
          id: 'r1-2',
          name: 'Отвод ⌀100',
          categoryName: 'Канализация',
          subcategoryName: 'Отвод',
          quantity: 16,
          unit: MaterialUnit.piece,
        ),
        RequestItem(
          id: 'r1-3',
          name: 'Тройник ⌀100/100/90°',
          categoryName: 'Канализация',
          subcategoryName: 'Тройник',
          quantity: 8,
          unit: MaterialUnit.piece,
        ),
        RequestItem(
          id: 'r1-4',
          name: 'Клипс ⌀100',
          categoryName: 'Канализация',
          subcategoryName: 'Клипс',
          quantity: 40,
          unit: MaterialUnit.piece,
        ),
      ],
    ),
    MaterialRequest(
      id: 'r2',
      name: 'Котельная — обвязка насосов',
      createdAt: DateTime(2026, 9, 2),
      status: RequestStatus.sent,
      folderId: 'f2',
      items: const [
        RequestItem(
          id: 'r2-1',
          name: 'Труба ⌀25',
          categoryName: 'ППР',
          subcategoryName: 'Труба',
          quantity: 45,
          unit: MaterialUnit.meter,
        ),
        RequestItem(
          id: 'r2-2',
          name: 'Кран пластиковый ⌀20',
          categoryName: 'ППР',
          subcategoryName: 'Кран',
          quantity: 6,
          unit: MaterialUnit.piece,
        ),
        RequestItem(
          id: 'r2-3',
          name: 'Кран ⌀½" н.р./в.р.',
          categoryName: 'Металлический фитинг',
          subcategoryName: 'Кран',
          quantity: 4,
          unit: MaterialUnit.piece,
        ),
      ],
    ),
    MaterialRequest(
      id: 'r3',
      name: 'Склад №3, расходники',
      createdAt: DateTime(2026, 8, 28),
      status: RequestStatus.saved,
      folderId: 'f3',
      items: const [
        RequestItem(
          id: 'r3-1',
          name: 'Саморез по дереву 41',
          categoryName: 'Расходный материал',
          subcategoryName: 'Саморез',
          quantity: 300,
          unit: MaterialUnit.piece,
        ),
        RequestItem(
          id: 'r3-2',
          name: 'Бур ⌀10',
          categoryName: 'Расходный материал',
          subcategoryName: 'Бур',
          quantity: 5,
          unit: MaterialUnit.piece,
        ),
      ],
    ),
  ];

  int _nextId = 1;

  Future<T> _delayed<T>(T Function() compute) async {
    await Future<void>.delayed(_latency);
    return compute();
  }

  MaterialRequest _find(String id) {
    final request = _requests.where((r) => r.id == id).firstOrNull;
    if (request == null) {
      throw const DescribedFailure('Заявка не найдена. Возможно, её удалили.');
    }
    return request;
  }

  @override
  Future<RequestList> list(RequestsParams params) => _delayed(() {
    final needle = params.query.trim().toLowerCase();
    return RequestList(
      items: [
        for (final request in _requests)
          if (_matchesFolder(request, params.folderId) &&
              _matchesFilter(request, params.filter) &&
              _matchesQuery(request, needle))
            request,
      ],
      total: _requests.length,
    );
  });

  static bool _matchesFolder(MaterialRequest request, String? folderId) =>
      folderId == null || request.folderId == folderId;

  static bool _matchesFilter(MaterialRequest request, RequestFilter filter) =>
      switch (filter) {
        RequestFilter.all => true,
        RequestFilter.drafts => request.status == RequestStatus.draft,
        RequestFilter.saved => request.status == RequestStatus.saved,
        RequestFilter.sent => request.status == RequestStatus.sent,
      };

  /// Поиск идёт и по названиям материалов внутри: «в какой заявке была
  /// труба ⌀100» — это вопрос, который задают чаще, чем помнят её название.
  static bool _matchesQuery(MaterialRequest request, String needle) {
    if (needle.isEmpty) return true;
    if (request.name.toLowerCase().contains(needle)) return true;
    return request.items.any(
      (item) => item.name.toLowerCase().contains(needle),
    );
  }

  @override
  Future<MaterialRequest> byId(String id) => _delayed(() => _find(id));

  @override
  Future<MaterialRequest> create({String? folderId}) => _delayed(() {
    final request = MaterialRequest(
      id: 'r-${_nextId++}',
      name: 'Заявка от ${_formatDate(_today)}',
      createdAt: _today,
      status: RequestStatus.draft,
      folderId: folderId,
      items: const [],
    );
    _requests.insert(0, request);
    return request;
  });

  @override
  Future<MaterialRequest> update(MaterialRequest request) => _delayed(() {
    // Любая правка возвращает заявку в черновик: сохранённые на устройство
    // XML и PDF после неё уже не соответствуют содержимому, и статус
    // «Сохранена» стал бы враньём.
    final draft = MaterialRequest(
      id: request.id,
      name: request.name,
      createdAt: request.createdAt,
      status: RequestStatus.draft,
      folderId: request.folderId,
      items: request.items,
    );
    _replace(draft);
    return draft;
  });

  @override
  Future<void> delete(String id) =>
      _delayed(() => _requests.removeWhere((r) => r.id == id));

  @override
  Future<MaterialRequest> save(String id) =>
      _delayed(() => _withStatus(_find(id), RequestStatus.saved));

  @override
  Future<MaterialRequest> send(String id, SendFormat format) =>
      _delayed(() => _withStatus(_find(id), RequestStatus.sent));

  MaterialRequest _withStatus(MaterialRequest request, RequestStatus status) {
    final updated = MaterialRequest(
      id: request.id,
      name: request.name,
      createdAt: request.createdAt,
      status: status,
      folderId: request.folderId,
      items: request.items,
    );
    _replace(updated);
    return updated;
  }

  void _replace(MaterialRequest request) {
    final index = _requests.indexWhere((r) => r.id == request.id);
    if (index >= 0) _requests[index] = request;
  }

  @override
  Future<List<RequestFolder>> folders() => _delayed(
    () => [
      for (final folder in _folders)
        RequestFolder(
          id: folder.id,
          name: folder.name,
          requestCount: _requests.where((r) => r.folderId == folder.id).length,
        ),
    ],
  );

  @override
  Future<RequestFolder> createFolder(String name) => _delayed(() {
    final id = 'f-${_nextId++}';
    _folders.add((id: id, name: name));
    return RequestFolder(id: id, name: name, requestCount: 0);
  });

  /// Дата в названии новой заявки: формат тот же, что показывает карточка,
  /// иначе название и подпись под ним выглядят из разных приложений.
  static String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.${date.year}';
}
