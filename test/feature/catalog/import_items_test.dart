import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/database/app_database.dart';
import 'package:request/feature/catalog/data/datasources/drift_catalog_local_data_source.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/import_row.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

import '../../support/catalog_fixture.dart';

void main() {
  late AppDatabase db;
  late DriftCatalogLocalDataSource source;

  setUp(() async {
    db = AppDatabase.executor(NativeDatabase.memory());
    source = DriftCatalogLocalDataSource(db);
    await source.replaceCatalog(catalogFixture());
  });

  tearDown(() => db.close());

  Future<CatalogCategory> at(List<String> path) async {
    var level = await source.categories();
    late CatalogCategory found;
    for (final name in path) {
      found = level.firstWhere((category) => category.name == name);
      level = found.categories;
    }
    return found;
  }

  test('недостающие ветки создаются по пути строки', () async {
    final drainage = await at(['Канализация']);

    await source.importItems(drainage.id, const [
      ImportRow(
        path: ['Тройник', 'Чугунный'],
        name: 'Тройник ⌀100/100',
        unit: ItemUnit.piece,
      ),
    ]);

    final nested = await at(['Канализация', 'Тройник', 'Чугунный']);
    expect(nested.items.single.name, 'Тройник ⌀100/100');
    expect(nested.items.single.path, [
      'Канализация',
      'Тройник',
      'Чугунный',
    ]);
  });

  test('существующая ветка переиспользуется, а не дублируется', () async {
    final drainage = await at(['Канализация']);

    await source.importItems(drainage.id, const [
      ImportRow(path: ['Труба'], name: 'Труба ⌀50', unit: ItemUnit.piece),
      ImportRow(path: ['Труба'], name: 'Труба ⌀75', unit: ItemUnit.piece),
    ]);

    final after = await at(['Канализация']);
    // «Труба» была — второй такой же появиться не должно.
    expect(
      after.categories.where((c) => c.name == 'Труба'),
      hasLength(1),
    );
    expect(
      (await at(['Канализация', 'Труба'])).items.map((i) => i.name),
      containsAll(['Труба ⌀100/3000', 'Труба ⌀50', 'Труба ⌀75']),
    );
  });

  test('совпадение по названию обновляется, остальное добавляется', () async {
    final drainage = await at(['Канализация']);
    final before = (await at(['Канализация', 'Труба'])).items.single;

    await source.importItems(drainage.id, const [
      // Та же труба, но единица в файле другая.
      ImportRow(
        path: ['Труба'],
        name: 'Труба ⌀100/3000',
        unit: ItemUnit.meter,
      ),
      ImportRow(path: ['Труба'], name: 'Труба ⌀150', unit: ItemUnit.piece),
    ]);

    final items = (await at(['Канализация', 'Труба'])).items;
    expect(items, hasLength(2));
    final updated = items.firstWhere((i) => i.id == before.id);
    // Идентификатор тот же — позиции заявок не теряют ссылку.
    expect(updated.unit, ItemUnit.meter);
  });

  test('совпадение ищется в своей ветке, а не по всему справочнику',
      () async {
    final ppr = await at(['ППР']);

    await source.importItems(ppr.id, const [
      ImportRow(path: ['Труба'], name: 'Труба ⌀25', unit: ItemUnit.piece),
    ]);

    // «Труба ⌀25» в ППР уже была — она и обновилась.
    expect((await at(['ППР', 'Труба'])).items, hasLength(1));
    // А одноимённая в канализации не тронута: это разные материалы.
    expect(
      (await at(['Канализация', 'Труба'])).items.single.name,
      'Труба ⌀100/3000',
    );
  });

  test('импорт в корень раскладывает по названным веткам', () async {
    await source.importItems(null, const [
      ImportRow(
        path: ['Металлопластик', 'Фитинг'],
        name: 'Муфта ⌀20',
        unit: ItemUnit.piece,
      ),
    ]);

    final added = await at(['Металлопластик', 'Фитинг']);
    expect(added.items.single.name, 'Муфта ⌀20');
    expect((await at(['Металлопластик'])).parentId, isNull);
  });
}
