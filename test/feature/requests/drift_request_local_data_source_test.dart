import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/database/app_database.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/datasources/drift_catalog_local_data_source.dart';
import 'package:request/feature/catalog/domain/entities/catalog_item.dart';
import 'package:request/feature/catalog/presentation/catalog_flatten.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';
import 'package:request/feature/requests/data/datasources/drift_request_local_data_source.dart';
import 'package:request/feature/requests/domain/entities/material_request.dart';
import 'package:request/feature/requests/domain/entities/request_filter.dart';
import 'package:request/feature/requests/domain/entities/request_folder.dart';
import 'package:request/feature/requests/domain/entities/request_item.dart';
import 'package:request/feature/requests/domain/entities/request_status.dart';
import 'package:request/feature/requests/domain/entities/requests_params.dart';
import 'package:request/feature/requests/domain/entities/send_format.dart';

import '../../support/catalog_fixture.dart';

void main() {
  late AppDatabase db;
  late DriftCatalogLocalDataSource catalog;
  late DriftRequestLocalDataSource source;

  final createdAt = DateTime(2026, 9, 6);

  /// Материалы засеянного справочника по названию — заявке нужны их
  /// идентификаторы, а не выдуманные строки.
  late Map<String, CatalogItem> items;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    catalog = DriftCatalogLocalDataSource(db);
    source = DriftRequestLocalDataSource(db);

    await catalog.replaceCatalog(catalogFixture());
    items = {
      for (final item in flattenItems(await catalog.categories()))
        item.name: item,
    };
  });

  tearDown(() => db.close());

  Future<MaterialRequest> newRequest({String? folderId, String? name}) =>
      source.create(
        folderId: folderId,
        name: name ?? 'Заявка от 06.09.2026',
        createdAt: createdAt,
      );

  RequestItem positionOf(CatalogItem item, int quantity) => RequestItem(
    // Идентификатор новой позиции присваивает экран, и он не число.
    id: 'new-${item.name}',
    itemId: item.id,
    name: item.name,
    path: item.path,
    quantity: quantity,
    unit: item.unit,
  );

  test('созданная заявка — пустой черновик', () async {
    final request = await newRequest();

    expect(request.status, RequestStatus.draft);
    expect(request.items, isEmpty);
    expect(request.createdAt, createdAt);
    expect(await source.byId(request.id), isA<MaterialRequest>());
  });

  test('несуществующая заявка — отказ с фразой, а не пустая заявка', () async {
    await expectLater(source.byId('404'), throwsA(isA<DescribedFailure>()));
    await expectLater(source.byId('r1'), throwsA(isA<DescribedFailure>()));
  });

  test('позиции читаются с названием, путём и единицей из справочника',
      () async {
    final request = await newRequest();
    final saved = await source.update(
      request.withItems([positionOf(items['Труба ⌀25']!, 45)]),
    );

    final position = saved.items.single;
    expect(position.name, 'Труба ⌀25');
    expect(position.path, ['ППР', 'Труба']);
    expect(position.unit, ItemUnit.meter);
    expect(position.quantity, 45);
    expect(position.itemId, items['Труба ⌀25']!.id);
  });

  test('правка сохраняет идентификаторы уцелевших позиций', () async {
    final request = await newRequest();
    final saved = await source.update(
      request.withItems([
        positionOf(items['Труба ⌀25']!, 45),
        positionOf(items['Отвод ⌀100']!, 16),
      ]),
    );

    final kept = saved.items.first;
    final edited = await source.update(
      saved.withItems([
        kept.withQuantity(50),
        positionOf(items['Труба ⌀100/2000']!, 8),
      ]),
    );

    // Уцелевшая позиция сохранила идентификатор: иначе открытая шторка
    // замены количества ссылалась бы на строку, которой уже нет.
    expect(edited.items.first.id, kept.id);
    expect(edited.items.first.quantity, 50);
    // Пропавшая — удалена, новая — вставлена, порядок тот, что в списке.
    expect(edited.items.map((i) => i.name), [
      'Труба ⌀25',
      'Труба ⌀100/2000',
    ]);
  });

  test('правка возвращает заявку в черновик и снимает отметку о сохранении',
      () async {
    final request = await newRequest();
    final saved = await source.markSaved(request.id, DateTime(2026, 9, 7));
    expect(saved.status, RequestStatus.saved);

    final edited = await source.update(saved.withName('Другое название'));
    expect(edited.status, RequestStatus.draft);
    expect(edited.name, 'Другое название');
  });

  test('отправка запоминает формат, правка после неё не стирает факт отправки',
      () async {
    final request = await newRequest();
    final sent = await source.markSent(
      request.id,
      SendFormat.both,
      DateTime(2026, 9, 7),
    );
    expect(sent.status, RequestStatus.sent);

    final edited = await source.update(sent.withName('Поправили'));
    expect(edited.status, RequestStatus.draft);
  });

  test('удалённый из справочника материал оставляет позицию без ссылки',
      () async {
    final request = await newRequest();
    final saved = await source.update(
      request.withItems([positionOf(items['Труба ⌀25']!, 45)]),
    );

    await catalog.deleteItem(items['Труба ⌀25']!.id);

    final reread = await source.byId(saved.id);
    final position = reread.items.single;
    // Заявка — документ: количество и место позиции остаются, уходит
    // только ссылка. Подпись такой позиции выбирает экран.
    expect(position.id, saved.items.single.id);
    expect(position.itemId, isNull);
    expect(position.quantity, 45);
    expect(position.name, isEmpty);
    expect(position.path, isEmpty);
  });

  group('список', () {
    late MaterialRequest draft;
    late MaterialRequest sent;

    setUp(() async {
      draft = await newRequest(name: 'ЖК Северный, стояки Б2');
      draft = await source.update(
        draft.withItems([positionOf(items['Труба ⌀100/2000']!, 24)]),
      );

      sent = await newRequest(name: 'Котельная — обвязка насосов');
      sent = await source.update(
        sent.withItems([positionOf(items['Труба ⌀25']!, 45)]),
      );
      sent = await source.markSent(
        sent.id,
        SendFormat.xlsx,
        DateTime(2026, 9, 7),
      );
    });

    test('фильтр по статусу отбирает, общее число считает все', () async {
      final result = await source.list(
        const RequestsParams(filter: RequestFilter.sent),
      );

      expect(result.items.map((r) => r.id), [sent.id]);
      // Подзаголовок «2 заявки» считает все, а не найденные.
      expect(result.total, 2);
    });

    test('поиск идёт по названию заявки', () async {
      final result = await source.list(
        const RequestsParams(query: 'котельная'),
      );
      expect(result.items.map((r) => r.id), [sent.id]);
    });

    test('поиск идёт и по названиям материалов внутри заявки', () async {
      // «В какой заявке была труба ⌀100» спрашивают чаще, чем помнят
      // название заявки.
      final result = await source.list(
        const RequestsParams(query: 'труба ⌀100'),
      );
      expect(result.items.map((r) => r.id), [draft.id]);
    });

    test('папка отбирает заявки, счётчик папки считает их же', () async {
      final folder = await source.createFolder('Котельные');
      await source.update(
        MaterialRequest(
          id: sent.id,
          name: sent.name,
          createdAt: sent.createdAt,
          status: sent.status,
          folderId: folder.id,
          items: sent.items,
        ),
      );

      final inFolder = await source.list(
        RequestsParams(folderId: folder.id),
      );
      expect(inFolder.items.map((r) => r.id), [sent.id]);

      final folders = await source.folders();
      expect(folders.single.requestCount, 1);
    });

    test('удаление заявки уносит её позиции', () async {
      await source.delete(draft.id);

      final result = await source.list(const RequestsParams());
      expect(result.items.map((r) => r.id), [sent.id]);
      expect(result.total, 1);
      // Позиции удалённой заявки не должны находиться поиском.
      final orphans = await source.list(
        const RequestsParams(query: 'труба ⌀100'),
      );
      expect(orphans.items, isEmpty);
    });
  });

  group('перенос в папку', () {
    late MaterialRequest request;
    late RequestFolder boilers;

    setUp(() async {
      request = await newRequest();
      request = await source.update(
        request.withItems([positionOf(items['Труба ⌀25']!, 45)]),
      );
      boilers = await source.createFolder('Котельные');
    });

    test('сохранённая заявка переезжает, не теряя статус и позиции', () async {
      final saved = await source.markSaved(request.id, DateTime(2026, 9, 7));

      final moved = await source.moveToFolder(saved.id, boilers.id);

      // Папка не входит в документ: таблица и PDF на устройстве после переезда
      // описывают ту же заявку, и требовать сохранить заново незачем.
      expect(moved.status, RequestStatus.saved);
      expect(moved.folderId, boilers.id);
      expect(moved.items.single.id, saved.items.single.id);
      expect(moved.items.single.quantity, 45);
    });

    test('переносом наружу заявка выходит из папок', () async {
      await source.moveToFolder(request.id, boilers.id);

      final moved = await source.moveToFolder(request.id, null);

      expect(moved.folderId, isNull);
      expect((await source.folders()).single.requestCount, 0);
    });

    test('счётчик папки считает перенесённую заявку', () async {
      await source.moveToFolder(request.id, boilers.id);

      expect((await source.folders()).single.requestCount, 1);
      final inFolder = await source.list(
        RequestsParams(folderId: boilers.id),
      );
      expect(inFolder.items.map((r) => r.id), [request.id]);
    });

    test('несуществующая папка — отказ, заявка остаётся где была', () async {
      await source.moveToFolder(request.id, boilers.id);

      await expectLater(
        source.moveToFolder(request.id, '404'),
        throwsA(isA<DescribedFailure>()),
      );
      // Из шторки может приехать и не число, если папку успели удалить.
      await expectLater(
        source.moveToFolder(request.id, 'f1'),
        throwsA(isA<DescribedFailure>()),
      );
      expect((await source.byId(request.id)).folderId, boilers.id);
    });

    test('несуществующая заявка — отказ с фразой про заявку', () async {
      await expectLater(
        source.moveToFolder('404', boilers.id),
        throwsA(isA<DescribedFailure>()),
      );
    });
  });

  test('папки приезжают в порядке создания', () async {
    await source.createFolder('ЖК Северный');
    await source.createFolder('Котельные');
    await source.createFolder('Склад и расходники');

    final folders = await source.folders();
    expect(folders.map((f) => f.name), [
      'ЖК Северный',
      'Котельные',
      'Склад и расходники',
    ]);
    expect(folders.every((f) => f.requestCount == 0), isTrue);
  });
}
