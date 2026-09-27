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
      // Шапка — только на первом листе, в начале документа, а не в
      // заголовке страницы: на продолжении таблицы она занимала место
      // строк, а какая это заявка, видно по первому листу.
      build: (context) => [_header(request), _itemsTable(request)],
    ),
  );

  return document.save();
}

pw.Widget _header(MaterialRequest request) {
  // Строка собирается до дерева, а не в аргументе: анализатор локализации
  // не отличает документ от экрана и запрещает склейку литералов в
  // параметрах — хотя ARB здесь неприменим, у PDF нет локали читателя.
  final meta =
      '${_dateFormat.format(request.createdAt)}  ·  '
      'позиций: ${request.items.length}';

  return pw.Container(
  margin: const pw.EdgeInsets.only(bottom: 16),
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        pdfSafeText(request.name),
        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        meta,
        style: const pw.TextStyle(fontSize: 13.5, color: PdfColors.grey700),
      ),
      pw.SizedBox(height: 10),
      pw.Divider(height: 1, color: PdfColors.grey400),
      ],
    ),
  );
}

/// Строки разделены тонкой светлой линией снизу: без неё на длинной заявке
/// глаз соскальзывает с материала на количество соседней строки, а сетка
/// со всех сторон делает лист тяжелее, чем нужно.
const _rowLine = pw.BorderSide(color: PdfColors.grey500, width: 0.5);

pw.Widget _itemsTable(MaterialRequest request) => pw.TableHelper.fromTextArray(
  border: const pw.TableBorder(horizontalInside: _rowLine, bottom: _rowLine),
  // Шрифт крупный: заявку читают распечатанной, на складе и с расстояния
  // вытянутой руки, а не с экрана.
  headerStyle: pw.TextStyle(fontSize: 13.5, fontWeight: pw.FontWeight.bold),
  headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
  cellStyle: const pw.TextStyle(fontSize: 15),
  cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
  // Номер, количество и единица — по центру и в заголовке, и в строках:
  // короткое значение в широкой колонке, прижатое к краю, отрывается
  // от своего заголовка.
  headerAlignments: {
    0: pw.Alignment.center,
    2: pw.Alignment.center,
    3: pw.Alignment.center,
  },
  cellAlignments: {
    0: pw.Alignment.center,
    2: pw.Alignment.center,
    3: pw.Alignment.center,
  },
  columnWidths: {
    // Узкие колонки выросли вместе со шрифтом: «Кол-во» и «комплект»
    // в прежней ширине переносились по буквам.
    0: const pw.FixedColumnWidth(36),
    1: const pw.FlexColumnWidth(1),
    2: const pw.FixedColumnWidth(72),
    3: const pw.FixedColumnWidth(84),
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
