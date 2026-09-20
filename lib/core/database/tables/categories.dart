import 'package:drift/drift.dart';

/// Категории и подкатегории справочника в одной таблице.
///
/// `parentId == null` — корневая категория, иначе подкатегория. Самоссылка
/// вместо двух таблиц, потому что уровни отличаются только глубиной, а не
/// набором полей; `null` вместо ссылки на саму себя, потому что «корень
/// ссылается на корень» допускает цикл и ломает каскад при удалении.
///
/// Глубже двух уровней дерево не читается: справочник в домене — категория,
/// подкатегория, материал, и третий уровень было бы некуда положить.
@TableIndex(name: 'category_parent', columns: {#parentId})
@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get parentId => integer()
      .nullable()
      .references(Categories, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
