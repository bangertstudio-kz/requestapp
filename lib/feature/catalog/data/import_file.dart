import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';

import '../../../core/domain/described_exception.dart';
import '../domain/entities/import_row.dart';
import '../domain/entities/item_unit.dart';

/// Результат разбора файла: строки и то, что по дороге пришлось поправить.
class ParsedImportFile {
  const ParsedImportFile({
    required this.rows,
    required this.duplicatesRemoved,
    required this.rowsTrimmed,
    required this.rowsSkipped,
    required this.unknownUnits,
  });

  final List<ImportRow> rows;
  final int duplicatesRemoved;
  final int rowsTrimmed;
  final int rowsSkipped;
  final List<String> unknownUnits;
}

/// Лист, который ищем. Нет такого — берём первый: человек, собравший файл
/// в чате и сохранивший его из Excel, скорее оставит «Лист1», чем
/// переименует, и отказывать ему из-за названия вкладки незачем.
const importSheetName = 'Материалы';

/// Разделитель звеньев пути. Поэтому название категории не может его
/// содержать — единственное ограничение формата, и оно в промте сказано.
const importPathSeparator = '/';

/// Разбирает книгу Excel в строки импорта.
///
/// Прощает написание единиц и лишние пробелы, но не придумывает данные:
/// строка без названия пропускается, строка с неизвестной единицей —
/// тоже, и обе попадают в отчёт. Молча загруженный мусор находят
/// через неделю в отправленной заявке.
ParsedImportFile parseImportFile(List<int> bytes) {
  final Excel book;
  try {
    book = Excel.decodeBytes(_withRelativeTargets(bytes));
    // Ловим всё, а не только Exception: на мусорных байтах распаковщик
    // бросает Error, и он прошёл бы мимо — вместо фразы о формате человек
    // увидел бы падение.
  } catch (_) {
    throw const DescribedFailure(
      'Не удалось прочитать файл. Нужен Excel (.xlsx).',
    );
  }

  final sheet = book.tables[importSheetName] ?? book.tables.values.firstOrNull;
  if (sheet == null) {
    throw const DescribedFailure('В файле нет ни одного листа.');
  }

  final rows = <ImportRow>[];
  final seen = <String>{};
  final unknownUnits = <String>{};
  var duplicates = 0;
  var trimmed = 0;
  var skipped = 0;

  for (var index = 0; index < sheet.rows.length; index++) {
    final cells = sheet.rows[index];
    final rawPath = _cell(cells, 0);
    final rawName = _cell(cells, 1);
    final rawUnit = _cell(cells, 2);

    if (rawPath.isEmpty && rawName.isEmpty && rawUnit.isEmpty) continue;

    // Первая непустая строка — заголовок. Узнаём по содержимому, а не по
    // номеру: файл из чата иногда приезжает с пустой строкой сверху.
    if (rows.isEmpty && duplicates == 0 && skipped == 0 && _isHeader(rawName)) {
      continue;
    }

    final name = _squeeze(rawName);
    if (name.isEmpty) {
      skipped++;
      continue;
    }

    final unit = _unitOf(rawUnit);
    if (unit == null) {
      unknownUnits.add(_squeeze(rawUnit));
      skipped++;
      continue;
    }

    final path = [
      for (final part in rawPath.split(importPathSeparator))
        if (_squeeze(part).isNotEmpty) _squeeze(part),
    ];

    if (_touched(rawName) || _pathTouched(rawPath)) trimmed++;

    final key = '${path.join(importPathSeparator)}\u0000$name';
    if (!seen.add(key)) {
      duplicates++;
      continue;
    }

    rows.add(ImportRow(path: path, name: name, unit: unit));
  }

  if (rows.isEmpty) {
    throw const DescribedFailure(
      'В файле нет ни одной строки с материалом. '
      'Проверьте, что колонки идут в порядке: путь, материал, единица.',
    );
  }

  return ParsedImportFile(
    rows: rows,
    duplicatesRemoved: duplicates,
    rowsTrimmed: trimmed,
    rowsSkipped: skipped,
    unknownUnits: unknownUnits.toList(),
  );
}

String _cell(List<Data?> cells, int index) {
  if (index >= cells.length) return '';
  final value = cells[index]?.value;
  return value == null ? '' : value.toString();
}

/// Пробелы внутри тоже схлопываются: «Труба  ⌀100» и «Труба ⌀100» —
/// одна и та же труба, и как два материала они смотрятся ошибкой ввода.
String _squeeze(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ');

/// Понадобилась ли ячейке правка сверх ожидаемой.
///
/// Пробелы вокруг разделителя пути — часть формата (« / »), и считать их
/// поправкой значит показывать предупреждение на каждой строке файла.
/// Отмечаем только лишнее: обрамляющие пробелы ячейки и сдвоенные внутри.
bool _touched(String raw) {
  final trimmed = raw.trim();
  return raw != trimmed || _squeeze(trimmed) != trimmed;
}

bool _pathTouched(String rawPath) =>
    rawPath != rawPath.trim() ||
    rawPath
        .split(importPathSeparator)
        .any((part) => _squeeze(part.trim()) != part.trim());

bool _isHeader(String name) {
  final value = _squeeze(name).toLowerCase();
  return value == 'материал' || value == 'название';
}

/// Написание единицы прощается: файл собирает человек в чате, и «шт» без
/// точки — не повод пропустить строку.
ItemUnit? _unitOf(String raw) {
  // Точки, дефисы и пробелы снимаются: «м.п», «к-т» и «м п» — то же самое,
  // что «мп», «кт» и «мп».
  final value = _squeeze(raw)
      .toLowerCase()
      .replaceAll(RegExp(r'[.\-\s]'), '');
  return switch (value) {
    'шт' || 'штука' || 'штуки' || 'штук' => ItemUnit.piece,
    'мп' || 'м' || 'метр' || 'метры' || 'метров' || 'метрпогонный' =>
      ItemUnit.meter,
    'комплект' || 'компл' || 'кт' || 'набор' => ItemUnit.set,
    _ => null,
  };
}

/// Переписывает абсолютные ссылки между частями книги в относительные.
///
/// В OOXML связь может указывать на часть и так, и так: `worksheets/sheet1.xml`
/// и `/xl/worksheets/sheet1.xml` одинаково законны. Пакет `excel` понимает
/// только первое — второе он склеивает с «xl/» и ищет `xl//xl/worksheets/...`,
/// не находит и падает.
///
/// Абсолютные пути пишут распространённые генераторы (ExcelJS и подобные),
/// а файлы для импорта собирает чат — то есть чем угодно. Отказывать
/// на валидном файле из-за особенности библиотеки нельзя, поэтому
/// приводим ссылки к тому виду, который она понимает.
List<int> _withRelativeTargets(List<int> bytes) {
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes);
  } catch (_) {
    // Не zip вовсе — пусть об этом скажет разбор книги, с его фразой.
    return bytes;
  }

  var changed = false;
  final fixedArchive = Archive();

  for (final file in archive.files) {
    final rewritten = file.isFile && file.name.endsWith('.rels')
        ? _rewriteRels(file)
        : null;
    if (rewritten == null) {
      fixedArchive.addFile(file);
      continue;
    }
    fixedArchive.addFile(
      ArchiveFile(file.name, rewritten.length, rewritten),
    );
    changed = true;
  }

  return changed ? ZipEncoder().encode(fixedArchive)! : bytes;
}

/// Новое содержимое части связей или `null`, если править нечего.
List<int>? _rewriteRels(ArchiveFile file) {
  final String text;
  try {
    text = utf8.decode(file.content as List<int>);
  } catch (_) {
    return null;
  }
  if (!text.contains('Target="/')) return null;

  // Путь считается от каталога части: для `xl/_rels/workbook.xml.rels`
  // это `xl/`, для `_rels/.rels` — корень книги.
  final segments = file.name.split('/');
  final base = segments.length > 2
      ? '${segments.sublist(0, segments.length - 2).join('/')}/'
      : '';

  final fixed = text.replaceAllMapped(RegExp(r'Target="/([^"]*)"'), (match) {
    final target = match.group(1)!;
    final relative = base.isNotEmpty && target.startsWith(base)
        ? target.substring(base.length)
        : target;
    return 'Target="$relative"';
  });
  return fixed == text ? null : utf8.encode(fixed);
}
