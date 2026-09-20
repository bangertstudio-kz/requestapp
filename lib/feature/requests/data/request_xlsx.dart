import 'package:excel/excel.dart';

import '../../catalog/data/datasources/unit_mapping.dart';
import '../domain/entities/material_request.dart';

/// Заявка в книге Excel.
///
/// Excel, а не CSV: у снабженца заявка попадает в таблицу, где по колонке
/// количества считают сумму, а CSV с кириллицей и точкой с запятой каждый
/// раз открывается диалогом импорта — и половину времени в одну колонку.
///
/// Лист один и называется как заявка: книга с «Sheet1» не подсказывает,
/// что в ней, когда таких файлов в почте десяток.
List<int> requestToXlsx(MaterialRequest request) {
  final book = Excel.createExcel();
  final sheet = book[sheetName];

  sheet.appendRow([
    TextCellValue(_headerNumber),
    TextCellValue(_headerItem),
    TextCellValue(_headerQuantity),
    TextCellValue(_headerUnit),
  ]);

  for (var index = 0; index < request.items.length; index++) {
    final item = request.items[index];
    sheet.appendRow([
      IntCellValue(index + 1),
      // Материал, удалённый из справочника, приезжает без названия.
      // Пустая клетка у получателя заметнее, чем на экране.
      TextCellValue(item.name.isEmpty ? _itemDeleted : item.name),
      IntCellValue(item.quantity),
      TextCellValue(unitCodeOf(item.unit)),
    ]);
  }

  // Ширины под содержимое: «Труба ⌀100/2000» в колонке по умолчанию
  // показывается как «Труба ⌀10…», и заявку приходится расширять руками.
  sheet.setColumnWidth(0, 5);
  sheet.setColumnWidth(1, 42);
  sheet.setColumnWidth(2, 10);
  sheet.setColumnWidth(3, 12);

  // Лист по умолчанию заводится вместе с книгой и остаётся пустым.
  book.delete(_defaultSheet);

  final bytes = book.save();
  if (bytes == null) {
    throw StateError('Excel.save() вернул null: книгу собрать не удалось.');
  }
  return bytes;
}

/// Строки листа как текст — для предпросмотра.
///
/// Читает готовый файл, а не собирает таблицу из заявки заново: экран
/// обязан показывать то, что уйдёт, и вторая сборка тех же данных однажды
/// разойдётся с первой.
List<List<String>> readXlsxRows(List<int> bytes) {
  final book = Excel.decodeBytes(bytes);
  final sheet = book.tables[sheetName];
  if (sheet == null) return const [];

  return [
    for (final row in sheet.rows)
      [
        for (final cell in row) _cellText(cell?.value),
      ],
  ];
}

String _cellText(CellValue? value) => switch (value) {
  null => '',
  TextCellValue(:final value) => value.toString(),
  IntCellValue(:final value) => '$value',
  _ => value.toString(),
};

const sheetName = 'Заявка';

const _defaultSheet = 'Sheet1';
const _headerNumber = '№';
const _headerItem = 'Материал';
const _headerQuantity = 'Кол-во';
const _headerUnit = 'Ед.';
const _itemDeleted = 'Материал удалён';
