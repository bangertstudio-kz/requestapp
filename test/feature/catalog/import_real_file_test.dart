import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:request/feature/catalog/data/import_file.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

/// Настоящий файл, собранный чатом, а не нашим же писателем.
///
/// Он вскрыл то, чего синтетика не показывала: связи между частями книги
/// записаны абсолютным путём (`Target="/xl/worksheets/sheet1.xml"`), а
/// пакет `excel` понимает только относительный — склеивает его с «xl/»
/// и не находит лист. Файл при этом валиден: так пишут распространённые
/// генераторы, и чат собирает файл чем угодно.
const _file = 'assets/materials_import.xlsx';

void main() {
  test('файл с абсолютными ссылками между частями читается', () {
    final parsed = parseImportFile(File(_file).readAsBytesSync());

    expect(parsed.rows, hasLength(326));
    expect(parsed.rows.first.path, ['Канализация', 'Труба']);
    expect(parsed.rows.first.name, 'Труба ⌀40/250');
    expect(parsed.rows.first.unit, ItemUnit.piece);
  });

  test('inline-строки читаются наравне с общим словарём', () {
    // В этом файле нет sharedStrings.xml — текст лежит прямо в ячейках.
    // Наш собственный писатель делает наоборот, поэтому своими файлами
    // эта ветка не проверялась бы никогда.
    final parsed = parseImportFile(File(_file).readAsBytesSync());

    expect(parsed.rows.every((row) => row.name.isNotEmpty), isTrue);
    expect(parsed.rows.map((row) => row.path).every((p) => p.isNotEmpty), isTrue);
  });

  test('предупреждения не срабатывают на каждой строке', () {
    final parsed = parseImportFile(File(_file).readAsBytesSync());

    // Шесть полных дублей в прайсе есть на самом деле.
    expect(parsed.duplicatesRemoved, 6);
    expect(parsed.rowsSkipped, 0);
    expect(parsed.unknownUnits, isEmpty);
    // Пробелы вокруг « / » — часть формата, а не поправка. Считать их
    // правкой значило бы показывать предупреждение на всех 332 строках,
    // и человек перестал бы читать этот блок вовсе.
    expect(parsed.rowsTrimmed, lessThan(parsed.rows.length ~/ 10));
  });
}
