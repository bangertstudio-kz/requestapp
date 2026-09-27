import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/described_exception.dart';
import '../../../core/utils/latin_slug.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_export.dart';
import 'datasources/unit_mapping.dart';
import 'import_file.dart';

/// Справочник или одна его ветка в книге Excel.
///
/// Формат — ровно тот, что принимает импорт: лист «Материалы», колонки
/// «путь, материал, единица». Выгруженное можно поправить в Excel и
/// загрузить обратно в корень справочника — ветки встанут на свои места.
///
/// Путь — от корня справочника, даже когда выгружают одну ветку: файл
/// уходит из приложения, и без полного пути «Труба» в нём не отличить
/// канализационную от ППР.
///
/// Пустые ветки в файл не попадают: строка формата — это материал, а
/// категорию без материалов записать нечем.
List<int> catalogToXlsx(
  List<CatalogCategory> categories, {
  List<String> basePath = const [],
}) {
  final book = Excel.createExcel();
  final sheet = book[importSheetName];

  sheet.appendRow([
    TextCellValue(_headerPath),
    TextCellValue(_headerItem),
    TextCellValue(_headerUnit),
  ]);

  void append(CatalogCategory category, List<String> parentPath) {
    final path = [...parentPath, category.name];
    final pathText = path.join(' $importPathSeparator ');
    for (final item in category.items) {
      sheet.appendRow([
        TextCellValue(pathText),
        TextCellValue(item.name),
        TextCellValue(unitCodeOf(item.unit)),
      ]);
    }
    for (final child in category.categories) {
      append(child, path);
    }
  }

  for (final category in categories) {
    append(category, basePath);
  }

  sheet.setColumnWidth(0, 40);
  sheet.setColumnWidth(1, 42);
  sheet.setColumnWidth(2, 12);

  // Лист по умолчанию заводится вместе с книгой и остаётся пустым.
  book.delete(_defaultSheet);

  final bytes = book.save();
  if (bytes == null) {
    throw StateError('Excel.save() вернул null: книгу собрать не удалось.');
  }
  return bytes;
}

/// Собирает выгрузку справочника или ветки [categoryId]: имя файла и книгу.
///
/// Общая для обоих репозиториев: выгрузка читает только дерево, а дерево
/// у них одинаковое.
CatalogExport buildCatalogExport(
  List<CatalogCategory> categories, {
  required String? categoryId,
  DateTime? now,
}) {
  final date = DateFormat('yyyy-MM-dd').format(now ?? DateTime.now());

  final String stem;
  final List<CatalogCategory> roots;
  final List<String> basePath;
  if (categoryId == null) {
    stem = 'spravochnik-$date';
    roots = categories;
    basePath = const [];
  } else {
    final chain = _chainTo(categories, categoryId);
    if (chain == null) throw const DescribedFailure('Категория не найдена.');
    final slug = latinSlug(chain.last.name);
    stem = slug.isEmpty ? 'spravochnik-$date' : 'spravochnik-$date-$slug';
    roots = [chain.last];
    basePath = [
      for (final parent in chain.take(chain.length - 1)) parent.name,
    ];
  }

  if (!roots.any(_hasItems)) {
    throw DescribedFailure(
      categoryId == null
          ? 'В справочнике нет материалов — выгружать нечего.'
          : 'В категории нет материалов — выгружать нечего.',
    );
  }

  return CatalogExport(
    name: '$stem.xlsx',
    bytes: Uint8List.fromList(catalogToXlsx(roots, basePath: basePath)),
  );
}

/// Ветки от корня до категории включительно или `null`, если её нет.
List<CatalogCategory>? _chainTo(List<CatalogCategory> level, String id) {
  for (final category in level) {
    if (category.id == id) return [category];
    final below = _chainTo(category.categories, id);
    if (below != null) return [category, ...below];
  }
  return null;
}

bool _hasItems(CatalogCategory category) =>
    category.items.isNotEmpty || category.categories.any(_hasItems);

const _defaultSheet = 'Sheet1';
const _headerPath = 'Путь';
const _headerItem = 'Материал';
const _headerUnit = 'Ед.';
