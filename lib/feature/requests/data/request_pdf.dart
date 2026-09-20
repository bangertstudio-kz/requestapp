import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../catalog/data/datasources/unit_mapping.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_item.dart';

/// Заменяет символы, которых нет в шрифте документа.
///
/// В прайсе заказчика диаметр записан двумя разными знаками — `⌀` (U+2300)
/// и `∅` (U+2205), вместе 291 название из 383. Ни одного из них нет в IBM
/// Plex; на экране их дорисовывает системный шрифт, а в PDF подставлять
/// нечего, и пакет молча выбрасывает символ. «Труба 100/2000» вместо
/// «Труба ⌀100/2000» у поставщика читается как другая позиция.
///
/// `Ø` (U+00D8) есть во всех шрифтах проекта и означает на чертеже ровно
/// то же самое. Подстановка только для печати: в таблицу уезжает исходное
/// название — там шрифт свой, и менять символ значило бы менять содержимое.
String pdfSafeText(String value) => value
    .replaceAll('\u2300', '\u00D8')
    .replaceAll('\u2205', '\u00D8');

/// Шрифты документа.
///
/// Отдельный тип, а не чтение внутри сборки: встроенные шрифты пакета `pdf`
/// кириллицы не знают и печатают квадраты, поэтому шрифт обязателен — а
/// обязательный аргумент виден в сигнатуре, в отличие от загрузки, спрятанной
/// в теле. Заодно сборку можно проверить тестом, не поднимая связку Flutter.
class RequestPdfFonts {
  const RequestPdfFonts({required this.regular, required this.bold});

  final pw.Font regular;
  final pw.Font bold;

  /// Берём из дизайн-системы, а не кладём второй такой же файл в assets:
  /// IBM Plex Sans уже в сборке и знает кириллицу. Заявка на бумаге выходит
  /// набранной тем же шрифтом, что и экран, с которого её отправили.
  static Future<RequestPdfFonts> fromBundle() async => RequestPdfFonts(
    regular: pw.Font.ttf(await rootBundle.load(_regular)),
    bold: pw.Font.ttf(await rootBundle.load(_semiBold)),
  );

  static const _regular = 'packages/request_ui/fonts/IBMPlexSans-Regular.ttf';
  static const _semiBold = 'packages/request_ui/fonts/IBMPlexSans-SemiBold.ttf';
}

/// Заявка в PDF: шапка и таблица позиций.
Future<Uint8List> requestToPdf(
  MaterialRequest request,
  RequestPdfFonts fonts,
) async {
  final theme = pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold);
  final document = pw.Document(title: request.name);

  document.addPage(
    pw.MultiPage(
      theme: theme,
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      // Шапка повторяется на каждой странице: заявка на сорок позиций
      // уезжает на второй лист, а лист без названия — просто столбик чисел
      // на столе у кладовщика.
      header: (context) => _header(request, context.pageNumber),
      build: (context) => [_itemsTable(request)],
    ),
  );

  return document.save();
}

pw.Widget _header(MaterialRequest request, int pageNumber) {
  // Строка собирается до дерева, а не в аргументе: анализатор локализации
  // не отличает документ от экрана и запрещает склейку литералов в
  // параметрах — хотя ARB здесь неприменим, у PDF нет локали читателя.
  final meta =
      '${_dateFormat.format(request.createdAt)}  ·  '
      'позиций: ${request.items.length}  ·  лист $pageNumber';

  return pw.Container(
  margin: const pw.EdgeInsets.only(bottom: 16),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        pdfSafeText(request.name),
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        meta,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(height: 1, color: PdfColors.grey400),
      ],
    ),
  );
}

pw.Widget _itemsTable(MaterialRequest request) => pw.TableHelper.fromTextArray(
  border: null,
  headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
  headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
  cellStyle: const pw.TextStyle(fontSize: 10),
  cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
  headerAlignments: {2: pw.Alignment.centerRight},
  cellAlignments: {
    0: pw.Alignment.centerRight,
    2: pw.Alignment.centerRight,
  },
  columnWidths: {
    0: const pw.FixedColumnWidth(24),
    1: const pw.FlexColumnWidth(1),
    2: const pw.FixedColumnWidth(48),
    3: const pw.FixedColumnWidth(56),
  },
  headers: ['№', 'Материал', 'Кол-во', 'Ед.'],
  data: [
    for (var index = 0; index < request.items.length; index++)
      [
        '${index + 1}',
        _itemName(request.items[index]),
        '${request.items[index].quantity}',
        unitCodeOf(request.items[index].unit),
      ],
  ],
);

/// Материал, удалённый из справочника, приезжает без названия. Пустая клетка
/// в документе у поставщика заметнее, чем на экране, поэтому подпись есть.
///
/// Строка здесь, а не в ARB: документ собирается вне дерева виджетов, у него
/// нет локали читателя, и заявка уходит на русском независимо от того, на
/// каком языке смотрят приложение.
String _itemName(RequestItem item) =>
    item.name.isEmpty ? 'Материал удалён' : pdfSafeText(item.name);

final _dateFormat = DateFormat('dd.MM.yyyy');
