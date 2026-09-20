import 'package:drift/drift.dart';

/// Папка, в которой лежат заявки. Один уровень, без вложенности.
@DataClassName('FolderRow')
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  /// Ручной порядок папок. Хранится, хотя экран его пока не меняет:
  /// список папок без заданного порядка сортируется по имени, и добавить
  /// перетаскивание потом дешевле, чем мигрировать таблицу.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
