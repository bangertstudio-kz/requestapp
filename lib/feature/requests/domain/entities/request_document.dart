import 'dart:typed_data';

/// Один файл заявки — то, что уйдёт поставщику.
///
/// Содержимое, а не путь к файлу: в браузере файловой системы нет, а
/// предпросмотр, отправка и сохранение одинаково работают с байтами —
/// и на телефоне тоже, без временных файлов, которые кто-то должен чистить.
class RequestDocument {
  const RequestDocument({
    required this.format,
    required this.name,
    required this.bytes,
  });

  final DocumentFormat format;

  /// Имя, которое увидит получатель: `zayavka-2026-09-06-stoyaki-b2.xlsx`.
  final String name;

  final Uint8List bytes;

  int get sizeBytes => bytes.length;

  String get mimeType => switch (format) {
    DocumentFormat.xlsx =>
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    DocumentFormat.pdf => 'application/pdf',
  };
}

/// Ровно один файл — в отличие от `SendFormat`, где `both` означает два.
enum DocumentFormat { xlsx, pdf }
