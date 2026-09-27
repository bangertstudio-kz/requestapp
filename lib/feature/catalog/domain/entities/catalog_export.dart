import 'dart:typed_data';

/// Выгрузка справочника: готовый файл в памяти.
///
/// Байты, а не путь: в браузере диска нет, а отдать файл системному листу
/// «Поделиться» или загрузке можно и так, и так.
class CatalogExport {
  const CatalogExport({required this.name, required this.bytes});

  /// `spravochnik-2026-09-28.xlsx` — латиницей, с датой.
  final String name;
  final Uint8List bytes;

  static const mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
}
