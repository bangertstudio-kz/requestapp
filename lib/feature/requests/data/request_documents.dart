import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../../../core/utils/latin_slug.dart';
import '../../../core/utils/save_to_device.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_document.dart';
import '../domain/entities/send_format.dart';
import 'request_pdf.dart';
import 'request_xlsx.dart';

/// Сборка файлов заявки.
///
/// Отдельно от репозитория и тем более от хранилища: вид таблицы задаёт
/// принимающая сторона, вёрстку PDF — бумага, и меняются они не тогда,
/// когда меняется база.
abstract interface class RequestDocuments {
  /// Собирает файлы выбранных форматов в памяти — для предпросмотра и
  /// отправки. Не на диск: это черновики, а не архив, заявку правят, и
  /// собранный час назад файл описывает не её.
  Future<List<RequestDocument>> build(
    MaterialRequest request,
    SendFormat format,
  );

  /// Сохраняет оба файла на устройство: «Сохранить на устройство» — это
  /// про «найду через неделю», а не про «отправлю сейчас». В браузере —
  /// загрузкой.
  Future<void> save(MaterialRequest request);
}

/// Файлы заявки: сборка в памяти, сохранение — средствами платформы.
class FileRequestDocuments implements RequestDocuments {
  /// Запись приходит функцией: настоящая требует связки с платформой
  /// (каталог документов или загрузка в браузере), и тест подменяет её
  /// своей, чтобы увидеть, что и под какими именами ушло на сохранение.
  FileRequestDocuments({
    Future<void> Function(String name, Uint8List bytes)? saveFile,
  }) : _saveFile = saveFile ?? saveToDevice;

  final Future<void> Function(String name, Uint8List bytes) _saveFile;

  @override
  Future<List<RequestDocument>> build(
    MaterialRequest request,
    SendFormat format,
  ) => _build(request, _formatsOf(format));

  @override
  Future<void> save(MaterialRequest request) async {
    for (final document in await _build(request, DocumentFormat.values)) {
      await _saveFile(document.name, document.bytes);
    }
  }

  static List<DocumentFormat> _formatsOf(SendFormat format) =>
      switch (format) {
        SendFormat.xlsx => const [DocumentFormat.xlsx],
        SendFormat.pdf => const [DocumentFormat.pdf],
        SendFormat.both => DocumentFormat.values,
      };

  Future<List<RequestDocument>> _build(
    MaterialRequest request,
    List<DocumentFormat> formats,
  ) async {
    final stem = _fileStem(request);
    final fonts = formats.contains(DocumentFormat.pdf)
        ? await RequestPdfFonts.fromBundle()
        : null;

    return [
      for (final format in formats)
        RequestDocument(
          format: format,
          name: '$stem.${_extension(format)}',
          bytes: switch (format) {
            DocumentFormat.xlsx => Uint8List.fromList(requestToXlsx(request)),
            DocumentFormat.pdf => await requestToPdf(request, fonts!),
          },
        ),
    ];
  }

  static String _extension(DocumentFormat format) => switch (format) {
    DocumentFormat.xlsx => 'xlsx',
    DocumentFormat.pdf => 'pdf',
  };

  /// Имя файла: дата плюс название заявки латиницей.
  static String _fileStem(MaterialRequest request) {
    final date = _dateFormat.format(request.createdAt);
    final name = latinSlug(request.name);
    return name.isEmpty ? 'zayavka-$date' : 'zayavka-$date-$name';
  }

  static final _dateFormat = DateFormat('yyyy-MM-dd');
}
