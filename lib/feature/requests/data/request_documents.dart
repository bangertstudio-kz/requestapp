import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/latin_slug.dart';
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
  /// Собирает файлы выбранных форматов во временный каталог.
  ///
  /// Временный, потому что это черновики для отправки, а не архив: заявку
  /// правят, и собранный час назад файл описывает не её. Чистит система.
  Future<List<RequestDocument>> build(
    MaterialRequest request,
    SendFormat format,
  );

  /// Кладёт оба файла в каталог документов: «Сохранить на устройство» —
  /// это про «найду через неделю», а не про «отправлю сейчас».
  Future<List<RequestDocument>> save(MaterialRequest request);
}

/// Файлы заявки на диске устройства.
class FileRequestDocuments implements RequestDocuments {
  /// Каталоги приходят функциями, а не путями: настоящие из `path_provider`
  /// требуют связки с платформой, и тест, который должен проверить, что
  /// отправка кладёт файлы во временный каталог, а сохранение — в документы,
  /// иначе не запустить вовсе.
  FileRequestDocuments({
    Future<Directory> Function()? temporaryDirectory,
    Future<Directory> Function()? documentsDirectory,
  }) : _temporary = temporaryDirectory ?? getTemporaryDirectory,
       _documents = documentsDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _temporary;
  final Future<Directory> Function() _documents;

  @override
  Future<List<RequestDocument>> build(
    MaterialRequest request,
    SendFormat format,
  ) async => _write(request, _formatsOf(format), await _temporary());

  @override
  Future<List<RequestDocument>> save(MaterialRequest request) async =>
      _write(request, DocumentFormat.values, await _documents());

  static List<DocumentFormat> _formatsOf(SendFormat format) =>
      switch (format) {
        SendFormat.xlsx => const [DocumentFormat.xlsx],
        SendFormat.pdf => const [DocumentFormat.pdf],
        SendFormat.both => DocumentFormat.values,
      };

  Future<List<RequestDocument>> _write(
    MaterialRequest request,
    List<DocumentFormat> formats,
    Directory directory,
  ) async {
    final stem = _fileStem(request);
    final fonts = formats.contains(DocumentFormat.pdf)
        ? await RequestPdfFonts.fromBundle()
        : null;

    final documents = <RequestDocument>[];
    for (final format in formats) {
      final name = '$stem.${_extension(format)}';
      final file = File('${directory.path}/$name');

      switch (format) {
        case DocumentFormat.xlsx:
          await file.writeAsBytes(requestToXlsx(request));
        case DocumentFormat.pdf:
          await file.writeAsBytes(await requestToPdf(request, fonts!));
      }

      documents.add(
        RequestDocument(
          format: format,
          name: name,
          path: file.path,
          sizeBytes: await file.length(),
        ),
      );
    }
    return documents;
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
