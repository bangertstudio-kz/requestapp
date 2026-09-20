import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/import_file.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

/// Настоящая книга Excel из строк — файл разбирается тем же путём, что
/// и присланный человеком.
List<int> book(List<List<String>> rows, {String sheet = importSheetName}) {
  final excel = Excel.createExcel();
  final target = excel[sheet];
  for (final row in rows) {
    target.appendRow([for (final cell in row) TextCellValue(cell)]);
  }
  if (sheet != 'Sheet1') excel.delete('Sheet1');
  return excel.save()!;
}

const _header = ['Путь', 'Материал', 'Единица'];

void main() {
  test('заголовок пропускается, строки разбираются', () {
    final parsed = parseImportFile(
      book([
        _header,
        ['Труба / Чугунная', 'Труба ⌀100/2000', 'шт.'],
        ['Отвод', 'Отвод ⌀100', 'шт.'],
      ]),
    );

    expect(parsed.rows, hasLength(2));
    expect(parsed.rows.first.path, ['Труба', 'Чугунная']);
    expect(parsed.rows.first.name, 'Труба ⌀100/2000');
    expect(parsed.rows.last.path, ['Отвод']);
  });

  test('пустой путь — материал ложится в выбранную категорию', () {
    final parsed = parseImportFile(
      book([
        _header,
        ['', 'Клипс ⌀100', 'шт.'],
      ]),
    );

    expect(parsed.rows.single.path, isEmpty);
  });

  test('написание единицы прощается', () {
    // Файл собирает человек в чате: «шт» без точки — не повод потерять
    // строку, а «м2» — повод, и о нём надо сказать.
    final parsed = parseImportFile(
      book([
        _header,
        ['А', 'Штуками', 'ШТ'],
        ['А', 'Метрами', 'м.п'],
        ['А', 'Комплектом', 'к-т'],
        ['А', 'Квадратами', 'м2'],
      ]),
    );

    expect(parsed.rows.map((r) => r.unit), [
      ItemUnit.piece,
      ItemUnit.meter,
      ItemUnit.set,
    ]);
    expect(parsed.unknownUnits, ['м2']);
    expect(parsed.rowsSkipped, 1);
  });

  test('дубли схлопываются, лишние пробелы убираются', () {
    final parsed = parseImportFile(
      book([
        _header,
        ['Труба', 'Труба ⌀100', 'шт.'],
        ['  Труба ', '  Труба  ⌀100  ', 'шт.'],
      ]),
    );

    // Обе строки — одна и та же труба: как два материала они смотрелись
    // бы ошибкой ввода.
    expect(parsed.rows, hasLength(1));
    expect(parsed.duplicatesRemoved, 1);
    expect(parsed.rowsTrimmed, 1);
  });

  test('строка без названия пропускается, а не грузится пустой', () {
    final parsed = parseImportFile(
      book([
        _header,
        ['Труба', '', 'шт.'],
        ['Труба', 'Труба ⌀100', 'шт.'],
      ]),
    );

    expect(parsed.rows, hasLength(1));
    expect(parsed.rowsSkipped, 1);
  });

  test('лист берётся первый, если «Материалы» не нашлось', () {
    // Человек сохранил из Excel и не переименовал вкладку — отказывать
    // из-за названия незачем.
    final parsed = parseImportFile(
      book([
        _header,
        ['Труба', 'Труба ⌀100', 'шт.'],
      ], sheet: 'Sheet1'),
    );

    expect(parsed.rows, hasLength(1));
  });

  test('файл без единой годной строки — отказ с фразой', () {
    expect(
      () => parseImportFile(book([_header])),
      throwsA(isA<DescribedFailure>()),
    );
    expect(
      () => parseImportFile(const [1, 2, 3]),
      throwsA(isA<DescribedFailure>()),
    );
  });
}
