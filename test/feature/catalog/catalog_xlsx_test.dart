import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/catalog_xlsx.dart';
import 'package:request/feature/catalog/data/import_file.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';

import '../../support/catalog_fixture.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('catalog_export');
  });

  tearDown(() => dir.delete(recursive: true));

  List<String> rowsOf(ParsedImportFile parsed) => [
    for (final row in parsed.rows)
      '${row.path.join(' / ')} | ${row.name} | ${row.unit.name}',
  ];

  test('выгрузка читается импортом обратно без потерь', () {
    final parsed = parseImportFile(catalogToXlsx(catalogFixture()));

    expect(rowsOf(parsed), [
      'Канализация / Труба | Труба ⌀100/3000 | piece',
      'Канализация / Труба / Чугунная | Труба ⌀100/2000 | piece',
      'Канализация / Отвод | Отвод ⌀100 | piece',
      'ППР / Труба | Труба ⌀25 | meter',
      'Расходный материал | Саморез по дереву 41 | piece',
    ]);
    // Заголовок узнан, ничего не поправлено и не пропущено.
    expect(parsed.rowsSkipped, 0);
    expect(parsed.rowsTrimmed, 0);
    expect(parsed.duplicatesRemoved, 0);
  });

  test('ветка выгружается с путём от корня справочника', () async {
    final path = await writeCatalogXlsx(
      catalogFixture(),
      categoryId: 'c1-s1',
      directory: dir,
      now: DateTime(2026, 9, 28),
    );

    expect(path, endsWith('spravochnik-2026-09-28-truba.xlsx'));
    final parsed = parseImportFile(await File(path).readAsBytes());
    expect(rowsOf(parsed), [
      'Канализация / Труба | Труба ⌀100/3000 | piece',
      'Канализация / Труба / Чугунная | Труба ⌀100/2000 | piece',
    ]);
  });

  test('весь справочник — файл без имени ветки', () async {
    final path = await writeCatalogXlsx(
      catalogFixture(),
      categoryId: null,
      directory: dir,
      now: DateTime(2026, 9, 28),
    );
    expect(path, endsWith('/spravochnik-2026-09-28.xlsx'));
  });

  test('пустая или ненайденная ветка — отказ с фразой', () async {
    for (final id in ['c2-s2', '404']) {
      await expectLater(
        writeCatalogXlsx(catalogFixture(), categoryId: id, directory: dir),
        throwsA(isA<DescribedFailure>()),
      );
    }
    await expectLater(
      writeCatalogXlsx(
        const [CatalogCategory(id: 'c', name: 'Пусто')],
        categoryId: null,
        directory: dir,
      ),
      throwsA(isA<DescribedFailure>()),
    );
  });
}
