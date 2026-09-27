import 'package:drift/drift.dart';

import 'categories.dart';
import 'units.dart';

/// Материал справочника.
///
/// Лежит всегда в подкатегории: `subcategoryId` указывает на запись
/// [Categories] с непустым `parentId`. Удаление ветки уносит материалы
/// каскадом — записи без категории показать негде.
@TableIndex(name: 'item_subcategory', columns: {#subcategoryId})
@TableIndex(name: 'item_name_lower', columns: {#nameLower})
@DataClassName('ItemRow')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get subcategoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  IntColumn get unitId => integer().references(Units, #id)();

  TextColumn get name => text()();

  /// То же название в нижнем регистре — только для поиска.
  ///
  /// Денормализация не от лени: `lower()` и `LIKE` в SQLite приводят регистр
  /// только у латиницы, поэтому «труба» не нашла бы «Труба ⌀100». Регистр
  /// снимает Dart при записи — он знает про Unicode, — а SQL сравнивает
  /// уже готовые строки. Колонку заполняет `normalizedName` в слое data,
  /// единственным путём на запись.
  TextColumn get nameLower => text()();

  /// Порядок материала внутри своей категории, с нуля.
  ///
  /// Задаётся руками, а не выводится из идентификатора: материалы
  /// переставляют перетаскиванием, и порядок строк прайса — только
  /// начальное значение. Новый материал встаёт в конец категории.
  IntColumn get position => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
