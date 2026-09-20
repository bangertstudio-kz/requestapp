import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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
  ///
  /// Транслитерация, а не кириллица как есть: файл уходит по почте на
  /// чужой компьютер, и имя, которое там превратится в «%D0%97...», ищут
  /// потом по дате изменения.
  static String _fileStem(MaterialRequest request) {
    final date = _dateFormat.format(request.createdAt);
    final name = _latin(request.name);
    return name.isEmpty ? 'zayavka-$date' : 'zayavka-$date-$name';
  }

  static String _latin(String value) {
    final buffer = StringBuffer();
    for (final rune in value.toLowerCase().runes) {
      final char = String.fromCharCode(rune);
      final replacement = _translit[char];
      if (replacement != null) {
        buffer.write(replacement);
      } else if (RegExp(r'[a-z0-9]').hasMatch(char)) {
        buffer.write(char);
      } else if (buffer.isNotEmpty && !buffer.toString().endsWith('-')) {
        // Всё остальное — один дефис подряд: «Склад №3, расходники»
        // не должно превращаться в «sklad---3--rashodniki».
        buffer.write('-');
      }
    }
    return buffer.toString().replaceAll(RegExp(r'-+$'), '');
  }

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  static const _translit = <String, String>{
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'e',
    'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm',
    'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
    'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh', 'щ': 'sch',
    'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya',
  };
}
