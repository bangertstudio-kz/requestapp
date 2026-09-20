import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/text_search.dart';
import '../../../../core/domain/described_exception.dart';
import '../../../catalog/data/datasources/unit_mapping.dart';
import '../../../catalog/domain/entities/item_unit.dart';
import '../../domain/entities/material_request.dart';
import '../../domain/entities/request_filter.dart';
import '../../domain/entities/request_folder.dart';
import '../../domain/entities/request_item.dart';
import '../../domain/entities/request_list.dart';
import '../../domain/entities/request_status.dart';
import '../../domain/entities/requests_params.dart';
import '../../domain/entities/send_format.dart';
import 'request_local_data_source.dart';

/// Заявки в SQLite через drift.
class DriftRequestLocalDataSource implements RequestLocalDataSource {
  const DriftRequestLocalDataSource(this._db);

  final AppDatabase _db;

  @override
  Future<RequestList> list(RequestsParams params) async {
    final query = _db.select(_db.requests)
      ..orderBy([
        (r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc),
        (r) => OrderingTerm(expression: r.id, mode: OrderingMode.desc),
      ]);

    final folderId = params.folderId;
    if (folderId != null) {
      query.where((r) => r.folderId.equals(_id(folderId)));
    }

    final status = _statusOf(params.filter);
    if (status != null) query.where((r) => r.status.equals(status));

    final needle = normalizedName(params.query);
    if (needle.isNotEmpty) {
      final pattern = containsPattern(params.query);
      query.where(
        (r) =>
            r.nameLower.like(pattern, escapeChar: likeEscapeChar) |
            existsQuery(_itemNameMatch(pattern)),
      );
    }

    final rows = await query.get();
    final items = await _itemsOf(rows.map((r) => r.id));

    return RequestList(
      items: [
        for (final row in rows)
          _request(row, items[row.id] ?? const <RequestItem>[]),
      ],
      // Всего заявок, а не найденных: подзаголовок «3 заявки» считает все,
      // и второй запрос ради одного экрана рано или поздно разъехался бы
      // с первым.
      total: await _count(_db.requests),
    );
  }

  /// Коррелированный подзапрос «в заявке есть материал с таким названием».
  ///
  /// В SQL, а не в Dart: «в какой заявке была труба ⌀100» спрашивают чаще,
  /// чем помнят её название, и отвечать на это перебором всех позиций всех
  /// заявок в памяти — значит поднимать базу целиком на каждую букву.
  JoinedSelectStatement<HasResultSet, dynamic> _itemNameMatch(String pattern) =>
      _db.selectOnly(_db.requestItems)
        ..addColumns([_db.requestItems.id])
        ..join([
          innerJoin(
            _db.items,
            _db.items.id.equalsExp(_db.requestItems.itemId),
          ),
        ])
        ..where(
          _db.requestItems.requestId.equalsExp(_db.requests.id) &
              _db.items.nameLower.like(pattern, escapeChar: likeEscapeChar),
        );

  // `async`, хотя тело в одну строку: разбор идентификатора бросает, и у
  // метода, возвращающего `Future`, отказ обязан приехать этим `Future`,
  // а не мимо него — иначе `catchError` на вызывающей стороне его не увидит.
  @override
  Future<MaterialRequest> byId(String id) async => _byId(_id(id));

  @override
  Future<MaterialRequest> create({
    String? folderId,
    required String name,
    required DateTime createdAt,
  }) async {
    final id = await _db
        .into(_db.requests)
        .insert(
          RequestsCompanion.insert(
            folderId: Value(folderId == null ? null : _id(folderId)),
            name: name,
            nameLower: normalizedName(name),
            status: _statusName(RequestStatus.draft),
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
        );
    return _byId(id);
  }

  @override
  Future<MaterialRequest> update(MaterialRequest request) =>
      _db.transaction(() async {
        final id = _id(request.id);
        await _writeItems(id, request.items);

        final folderId = request.folderId;
        final updated =
            await (_db.update(_db.requests)..where((r) => r.id.equals(id)))
                .write(
                  RequestsCompanion(
                    name: Value(request.name),
                    nameLower: Value(normalizedName(request.name)),
                    folderId: Value(folderId == null ? null : _id(folderId)),
                    // Правка возвращает заявку в черновик и снимает отметку
                    // о сохранении: таблица и PDF на устройстве после неё
                    // описывают не то, что теперь в заявке.
                    status: Value(_statusName(RequestStatus.draft)),
                    savedAt: const Value(null),
                    // `sentAt` и `lastSentFormat` остаются: заявку правда
                    // отправляли, и это факт, а не состояние. Заодно шторка
                    // отправки помнит, каким форматом отправляли в прошлый раз.
                    updatedAt: Value(DateTime.now()),
                  ),
                );
        if (updated == 0) throw _notFound;

        return _byId(id);
      });

  /// Сверяет позиции по идентификатору вместо «удалить все и записать
  /// заново»: иначе у каждой позиции при каждой правке менялся бы
  /// идентификатор, и открытая шторка замены количества ссылалась бы
  /// на строку, которой уже нет.
  Future<void> _writeItems(int requestId, List<RequestItem> items) async {
    final existing =
        await (_db.select(_db.requestItems)
              ..where((i) => i.requestId.equals(requestId)))
            .get();
    final existingIds = {for (final row in existing) row.id};
    final kept = <int>{};

    for (var position = 0; position < items.length; position++) {
      final item = items[position];
      // Идентификатор новой позиции присваивает экран, и он не число:
      // разбор молча вернёт null, и позиция вставится, а не перезапишет
      // чужую строку.
      final rowId = int.tryParse(item.id);
      final itemId = item.itemId == null ? null : int.tryParse(item.itemId!);

      if (rowId != null && existingIds.contains(rowId)) {
        kept.add(rowId);
        await (_db.update(_db.requestItems)..where((i) => i.id.equals(rowId)))
            .write(
              RequestItemsCompanion(
                itemId: Value(itemId),
                quantity: Value(item.quantity),
                position: Value(position),
                updatedAt: Value(DateTime.now()),
              ),
            );
      } else {
        await _db
            .into(_db.requestItems)
            .insert(
              RequestItemsCompanion.insert(
                requestId: requestId,
                itemId: Value(itemId),
                quantity: item.quantity,
                position: Value(position),
              ),
            );
      }
    }

    final removed = existingIds.difference(kept);
    if (removed.isNotEmpty) {
      await (_db.delete(_db.requestItems)
            ..where((i) => i.id.isIn(removed)))
          .go();
    }
  }

  @override
  Future<MaterialRequest> moveToFolder(String id, String? folderId) async {
    final rowId = _id(id);
    final target = folderId == null ? null : _folderIdOf(folderId);

    // Папку могли удалить, пока была открыта шторка. Без этой проверки
    // внешний ключ молча обнулил бы folder_id, и заявка оказалась бы
    // в корне — там, куда её никто не клал.
    if (target != null && !await _folderExists(target)) {
      throw _folderNotFound;
    }

    final updated =
        await (_db.update(_db.requests)..where((r) => r.id.equals(rowId)))
            .write(
              RequestsCompanion(
                folderId: Value(target),
                updatedAt: Value(DateTime.now()),
              ),
            );
    if (updated == 0) throw _notFound;

    return _byId(rowId);
  }

  Future<bool> _folderExists(int id) async =>
      await (_db.select(_db.folders)..where((f) => f.id.equals(id)))
          .getSingleOrNull() !=
      null;

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.requests)..where((r) => r.id.equals(_id(id)))).go();
  }

  @override
  Future<MaterialRequest> markSaved(String id, DateTime savedAt) => _mark(
    id,
    RequestsCompanion(
      status: Value(_statusName(RequestStatus.saved)),
      savedAt: Value(savedAt),
      updatedAt: Value(savedAt),
    ),
  );

  @override
  Future<MaterialRequest> markSent(
    String id,
    SendFormat format,
    DateTime sentAt,
  ) => _mark(
    id,
    RequestsCompanion(
      status: Value(_statusName(RequestStatus.sent)),
      sentAt: Value(sentAt),
      lastSentFormat: Value(_formatName(format)),
      updatedAt: Value(sentAt),
    ),
  );

  Future<MaterialRequest> _mark(String id, RequestsCompanion patch) async {
    final rowId = _id(id);
    final updated =
        await (_db.update(_db.requests)..where((r) => r.id.equals(rowId)))
            .write(patch);
    if (updated == 0) throw _notFound;
    return _byId(rowId);
  }

  @override
  Future<List<RequestFolder>> folders() async {
    final count = _db.requests.id.count();
    final rows =
        await (_db.select(_db.folders).join([
                leftOuterJoin(
                  _db.requests,
                  _db.requests.folderId.equalsExp(_db.folders.id),
                ),
              ])
              ..addColumns([count])
              ..groupBy([_db.folders.id])
              ..orderBy([
                OrderingTerm(expression: _db.folders.sortOrder),
                OrderingTerm(expression: _db.folders.id),
              ]))
            .get();

    return [
      for (final row in rows)
        RequestFolder(
          id: '${row.readTable(_db.folders).id}',
          name: row.readTable(_db.folders).name,
          requestCount: row.read(count) ?? 0,
        ),
    ];
  }

  @override
  Future<RequestFolder> createFolder(String name) async {
    // Порядок — следующий за последним, а не ноль на всех: папки должны
    // оставаться в том порядке, в каком их завели, иначе новая папка
    // каждый раз уезжает в середину списка по алфавиту.
    final maxOrder = _db.folders.sortOrder.max();
    final row = await (_db.selectOnly(_db.folders)..addColumns([maxOrder]))
        .getSingle();

    final id = await _db
        .into(_db.folders)
        .insert(
          FoldersCompanion.insert(
            name: name,
            sortOrder: Value((row.read(maxOrder) ?? 0) + 1),
          ),
        );
    return RequestFolder(id: '$id', name: name, requestCount: 0);
  }

  Future<MaterialRequest> _byId(int id) async {
    final row = await (_db.select(_db.requests)..where((r) => r.id.equals(id)))
        .getSingleOrNull();
    if (row == null) throw _notFound;

    final items = await _itemsOf([id]);
    return _request(row, items[id] ?? const <RequestItem>[]);
  }

  /// Позиции всех перечисленных заявок одним запросом: по запросу на заявку
  /// список из двадцати заявок стоил бы двадцати обращений к базе.
  Future<Map<int, List<RequestItem>>> _itemsOf(Iterable<int> requestIds) async {
    final ids = requestIds.toList();
    if (ids.isEmpty) return const {};

    final rows =
        await (_db.select(_db.requestItems).join([
                // Левое соединение: материал могли удалить из справочника,
                // и позиция остаётся без ссылки. Внутреннее молча выкинуло
                // бы её из отправленной заявки.
                leftOuterJoin(
                  _db.items,
                  _db.items.id.equalsExp(_db.requestItems.itemId),
                ),
              ])
              ..where(_db.requestItems.requestId.isIn(ids))
              ..orderBy([
                OrderingTerm(expression: _db.requestItems.position),
                OrderingTerm(expression: _db.requestItems.id),
              ]))
            .get();
    if (rows.isEmpty) return const {};

    // Путь собирается подъёмом по parent_id, а глубина дерева заранее
    // неизвестна — двумя соединениями, как раньше, уже не обойтись.
    // Категории читаются целиком: их полсотни, и это один запрос вместо
    // рекурсивного на каждую позицию.
    final categories = {
      for (final row in await _db.select(_db.categories).get()) row.id: row,
    };

    final result = <int, List<RequestItem>>{};
    for (final row in rows) {
      final requestItem = row.readTable(_db.requestItems);
      final item = row.readTableOrNull(_db.items);
      (result[requestItem.requestId] ??= []).add(
        RequestItem(
          id: '${requestItem.id}',
          // `null` — материала больше нет в справочнике. Подпись такой
          // позиции выбирает экран: название пустое, потому что показывать
          // тут нечего, а выдумывать фразу в слое данных нельзя — она
          // зависит от языка читателя.
          itemId: item == null ? null : '${item.id}',
          name: item?.name ?? '',
          path: item == null
              ? const []
              : _pathOf(categories, item.subcategoryId),
          quantity: requestItem.quantity,
          unit: item == null ? ItemUnit.piece : unitFromId(item.unitId),
        ),
      );
    }
    return result;
  }

  /// Названия категорий от корня. Петля в данных не должна превращаться
  /// в зависший экран, поэтому пройденное запоминаем.
  static List<String> _pathOf(Map<int, CategoryRow> categories, int id) {
    final names = <String>[];
    final seen = <int>{};
    for (var cursor = categories[id]; cursor != null;) {
      if (!seen.add(cursor.id)) break;
      names.insert(0, cursor.name);
      final parentId = cursor.parentId;
      cursor = parentId == null ? null : categories[parentId];
    }
    return names;
  }

  MaterialRequest _request(RequestRow row, List<RequestItem> items) =>
      MaterialRequest(
        id: '${row.id}',
        name: row.name,
        createdAt: row.createdAt,
        status: _statusFrom(row.status),
        folderId: row.folderId == null ? null : '${row.folderId}',
        items: items,
      );

  Future<int> _count(TableInfo<Table, dynamic> table) async {
    final count = countAll();
    final row = await (_db.selectOnly(table)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  static const _notFound = DescribedFailure(
    'Заявка не найдена. Возможно, её удалили.',
  );

  static const _folderNotFound = DescribedFailure(
    'Папка не найдена. Возможно, её удалили.',
  );

  /// Нечисловой идентификатор приходит из маршрута: опечатка в ссылке
  /// должна выглядеть как ненайденная заявка, а не как падение с
  /// `FormatException` в логах.
  static int _id(String value) => int.tryParse(value) ?? (throw _notFound);

  /// Отдельно от [_id]: у нечисловой папки своя фраза. «Заявка не найдена»
  /// в ответ на выбор папки отправило бы искать не ту пропажу.
  static int _folderIdOf(String value) =>
      int.tryParse(value) ?? (throw _folderNotFound);

  static String _statusName(RequestStatus status) => switch (status) {
    RequestStatus.draft => 'draft',
    RequestStatus.saved => 'saved',
    RequestStatus.sent => 'sent',
  };

  /// Неизвестный статус — черновик: заявку с испорченной строкой всё равно
  /// надо открыть и дать поправить, а «черновик» — единственное состояние,
  /// которое ничего не обещает про файлы на устройстве.
  static RequestStatus _statusFrom(String value) => switch (value) {
    'saved' => RequestStatus.saved,
    'sent' => RequestStatus.sent,
    _ => RequestStatus.draft,
  };

  static String? _statusOf(RequestFilter filter) => switch (filter) {
    RequestFilter.all => null,
    RequestFilter.drafts => 'draft',
    RequestFilter.saved => 'saved',
    RequestFilter.sent => 'sent',
  };

  static String _formatName(SendFormat format) => switch (format) {
    SendFormat.xlsx => 'xlsx',
    SendFormat.pdf => 'pdf',
    SendFormat.both => 'xlsx_pdf',
  };
}
