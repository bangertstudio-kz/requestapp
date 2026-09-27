import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/database/app_database.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/datasources/drift_catalog_local_data_source.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/item_draft.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

import '../../support/catalog_fixture.dart';

void main() {
  late AppDatabase db;
  late DriftCatalogLocalDataSource source;

  setUp(() {
    db = AppDatabase.executor(NativeDatabase.memory());
    source = DriftCatalogLocalDataSource(db);
  });

  tearDown(() => db.close());

  /// Категория с заданным путём — тесты про дерево иначе превращаются
  /// в цепочку индексов.
  Future<CatalogCategory> at(List<String> path) async {
    var level = await source.categories();
    late CatalogCategory found;
    for (final name in path) {
      found = level.firstWhere((category) => category.name == name);
      level = found.categories;
    }
    return found;
  }

  test('дерево читается на всю глубину, вместе с пустыми ветками', () async {
    final written = await source.replaceCatalog(catalogFixture());
    expect(written, 5);

    final categories = await source.categories();
    expect(categories.map((c) => c.name), [
      'Канализация',
      'ППР',
      'Расходный материал',
    ]);

    // Третий уровень: раньше его некуда было положить.
    final cast = await at(['Канализация', 'Труба', 'Чугунная']);
    expect(cast.items.single.name, 'Труба ⌀100/2000');
    expect(cast.items.single.path, [
      'Канализация',
      'Труба',
      'Чугунная',
    ]);

    // Материал рядом с вложенной веткой.
    final pipes = await at(['Канализация', 'Труба']);
    expect(pipes.categories.map((c) => c.name), ['Чугунная']);
    expect(pipes.items.map((i) => i.name), ['Труба ⌀100/3000']);

    // И материал прямо в корневой категории.
    final supplies = await at(['Расходный материал']);
    expect(supplies.categories, isEmpty);
    expect(supplies.items.single.path, ['Расходный материал']);

    expect((await at(['ППР', 'Кран'])).items, isEmpty);
  });

  test('parentId показывает место категории в дереве', () async {
    await source.replaceCatalog(catalogFixture());

    expect((await at(['Канализация'])).parentId, isNull);
    final pipes = await at(['Канализация', 'Труба']);
    expect(pipes.parentId, (await at(['Канализация'])).id);
  });

  group('поиск', () {
    setUp(() => source.replaceCatalog(catalogFixture()));

    test('не замечает регистр в кириллице', () async {
      // SQLite приводит регистр только у латиницы, поэтому «труба» нашла бы
      // ноль записей, если бы сравнение шло по исходной колонке.
      final found = await source.searchItems('труба');
      // Порядок — по идентификатору, то есть по порядку записи: материалы
      // ветки ложатся раньше материалов её вложенных.
      expect(found.map((i) => i.name), [
        'Труба ⌀100/3000',
        'Труба ⌀100/2000',
        'Труба ⌀25',
      ]);
    });

    test('путь приезжает целиком, любой длины', () async {
      final found = await source.searchItems('труба');
      expect(found[0].path, ['Канализация', 'Труба']);
      expect(found[1].path, ['Канализация', 'Труба', 'Чугунная']);
      expect(found[2].path, ['ППР', 'Труба']);

      final single = await source.searchItems('саморез');
      expect(single.single.path, ['Расходный материал']);
    });

    test('пустой запрос — пустой список, а не весь справочник', () async {
      expect(await source.searchItems('   '), isEmpty);
    });

    test('процент ищется как процент, а не как «что угодно»', () async {
      // Без экранирования «%» шаблон LIKE совпал бы со всем справочником.
      expect(await source.searchItems('%'), isEmpty);
    });
  });

  group('правка справочника', () {
    setUp(() => source.replaceCatalog(catalogFixture()));

    test('категория создаётся на верхнем уровне и внутри другой', () async {
      await source.saveCategory(name: 'Металлопластик', parentId: null);
      final root = await at(['Металлопластик']);
      expect(root.parentId, isNull);

      await source.saveCategory(name: 'Фитинг', parentId: root.id);
      expect((await at(['Металлопластик'])).categories.single.name, 'Фитинг');
    });

    test('подкатегория поднимается наверх вместе со своим содержимым',
        () async {
      final pipes = await at(['Канализация', 'Труба']);

      // Без родителя — значит наверх.
      await source.saveCategory(id: pipes.id, name: pipes.name, parentId: null);

      final moved = await at(['Труба']);
      expect(moved.parentId, isNull);
      // Ветка переехала целиком: потомки ссылались на неё, а не на её
      // прежнего родителя.
      expect(moved.categories.single.name, 'Чугунная');
      expect(moved.categories.single.items.single.path, [
        'Труба',
        'Чугунная',
      ]);
    });

    test('категория не уходит внутрь собственного потомка', () async {
      final drainage = await at(['Канализация']);
      final cast = await at(['Канализация', 'Труба', 'Чугунная']);

      await expectLater(
        source.saveCategory(
          id: drainage.id,
          name: drainage.name,
          parentId: cast.id,
        ),
        throwsA(isA<DescribedFailure>()),
      );
      // И внутрь самой себя тоже.
      await expectLater(
        source.saveCategory(
          id: drainage.id,
          name: drainage.name,
          parentId: drainage.id,
        ),
        throwsA(isA<DescribedFailure>()),
      );
      expect((await at(['Канализация'])).parentId, isNull);
    });

    test('материал переносится в категорию любого уровня', () async {
      final supplies = await at(['Расходный материал']);
      final cast = await at(['Канализация', 'Труба', 'Чугунная']);
      final screw = supplies.items.single;

      await source.saveItem(
        ItemDraft(
          id: screw.id,
          name: screw.name,
          categoryId: cast.id,
          unit: screw.unit,
        ),
      );

      expect((await at(['Расходный материал'])).items, isEmpty);
      final moved = await at(['Канализация', 'Труба', 'Чугунная']);
      expect(moved.items.map((i) => i.name), contains(screw.name));
    });

    test('новый и перенесённый материал встают в конец категории', () async {
      final cast = await at(['Канализация', 'Труба', 'Чугунная']);
      await source.saveItem(
        ItemDraft(
          id: null,
          name: 'Труба ⌀100/1000',
          categoryId: cast.id,
          unit: ItemUnit.piece,
        ),
      );
      final screw = (await at(['Расходный материал'])).items.single;
      await source.saveItem(
        ItemDraft(
          id: screw.id,
          name: screw.name,
          categoryId: cast.id,
          unit: screw.unit,
        ),
      );

      final items = (await at(['Канализация', 'Труба', 'Чугунная'])).items;
      expect(items.map((i) => i.name), [
        'Труба ⌀100/2000',
        'Труба ⌀100/1000',
        screw.name,
      ]);
      final positions = await (db.select(db.items)
            ..where((i) => i.subcategoryId.equals(int.parse(cast.id)))
            ..orderBy([(i) => OrderingTerm(expression: i.position)]))
          .map((row) => row.position)
          .get();
      expect(positions, [0, 1, 2]);
    });

    test('материал читается по позиции, а не по идентификатору', () async {
      final pipes = await at(['ППР', 'Труба']);
      await source.saveItem(
        ItemDraft(
          id: null,
          name: 'Труба ⌀32',
          categoryId: pipes.id,
          unit: ItemUnit.meter,
        ),
      );
      // Перестановку сделает drag & drop; пока — прямо в базе.
      await db.customStatement(
        'UPDATE items SET position = 1 - position WHERE subcategory_id = ?',
        [int.parse(pipes.id)],
      );

      final items = (await at(['ППР', 'Труба'])).items;
      expect(items.map((i) => i.name), ['Труба ⌀32', 'Труба ⌀25']);
    });

    test('перестановка сохраняет порядок и не трогает чужие материалы', () async {
      final pipes = await at(['ППР', 'Труба']);
      for (final name in ['Труба ⌀32', 'Труба ⌀40']) {
        await source.saveItem(
          ItemDraft(
            id: null,
            name: name,
            categoryId: pipes.id,
            unit: ItemUnit.meter,
          ),
        );
      }
      final items = (await at(['ППР', 'Труба'])).items;
      final stranger = (await at(['Расходный материал'])).items.single;

      await source.reorderItems(pipes.id, [
        items[2].id,
        items[0].id,
        items[1].id,
        // Материал другой категории сюда не переезжает и не перенумеровывается.
        stranger.id,
      ]);

      expect((await at(['ППР', 'Труба'])).items.map((i) => i.name), [
        'Труба ⌀40',
        'Труба ⌀25',
        'Труба ⌀32',
      ]);
      expect(
        (await at(['Расходный материал'])).items.single.id,
        stranger.id,
      );
    });

    test('удаление категории уносит всё поддерево', () async {
      final drainage = await at(['Канализация']);
      await source.deleteCategory(drainage.id);

      final left = await source.categories();
      expect(left.map((c) => c.name), ['ППР', 'Расходный материал']);
      // Третий уровень ушёл вместе с корнем.
      expect(await source.searchItems('Труба ⌀100'), isEmpty);
    });

    test('переименование переписывает путь во всех материалах ниже', () async {
      final drainage = await at(['Канализация']);
      await source.saveCategory(
        id: drainage.id,
        name: 'Канализация ПВХ',
        parentId: null,
      );

      final found = await source.searchItems('Труба ⌀100/2000');
      expect(found.single.path, [
        'Канализация ПВХ',
        'Труба',
        'Чугунная',
      ]);
    });

    test('ненайденный идентификатор — отказ с фразой', () async {
      await expectLater(
        source.saveCategory(id: '404', name: 'Нет такой', parentId: null),
        throwsA(isA<DescribedFailure>()),
      );
      // Из маршрута может приехать и не число — падать с FormatException
      // на опечатке в ссылке нельзя.
      await expectLater(
        source.saveCategory(id: 'c1', name: 'Нет такой', parentId: null),
        throwsA(isA<DescribedFailure>()),
      );
      await expectLater(
        source.saveItem(
          const ItemDraft(
            id: null,
            name: 'Кран',
            categoryId: '404',
            unit: ItemUnit.piece,
          ),
        ),
        throwsA(isA<DescribedFailure>()),
      );
    });
  });
  test('миграция v1 → v2 нумерует материалы по порядку в категории', () async {
    final dir = await Directory.systemTemp.createTemp('catalog_migration');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/db.sqlite');

    // Базу v1 получаем из текущей: снимаем колонку и версию схемы.
    final fresh = AppDatabase.executor(NativeDatabase(file));
    await DriftCatalogLocalDataSource(fresh).replaceCatalog(catalogFixture());
    await fresh.customStatement('ALTER TABLE items DROP COLUMN position');
    await fresh.customStatement('PRAGMA user_version = 1');
    await fresh.close();

    final upgraded = AppDatabase.executor(NativeDatabase(file));
    addTearDown(upgraded.close);
    final rows = await (upgraded.select(upgraded.items)
          ..orderBy([(i) => OrderingTerm(expression: i.id)]))
        .get();
    final bySubcategory = <int, List<int>>{};
    for (final row in rows) {
      (bySubcategory[row.subcategoryId] ??= []).add(row.position);
    }
    for (final positions in bySubcategory.values) {
      expect(positions, [for (var i = 0; i < positions.length; i++) i]);
    }
  });
}
