import 'package:drift/drift.dart';

import 'folders.dart';

/// Заявка на материалы.
///
/// Статус и формат отправки лежат строками, а не `textEnum`: перечисления
/// живут в домене фичи, и таблица, импортирующая `feature/`, развернула бы
/// зависимость core → feature. Перевод строки в перечисление делает датасорс —
/// там же, где остальная сериализация.
@TableIndex(name: 'request_folder', columns: {#folderId})
@DataClassName('RequestRow')
class Requests extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `null` — заявка вне папок. Удаление папки не удаляет заявки:
  /// «убрал папку — потерял три заявки» — не то, чего ждут от папки.
  IntColumn get folderId => integer()
      .nullable()
      .references(Folders, #id, onDelete: KeyAction.setNull)();

  TextColumn get name => text()();

  /// Название в нижнем регистре — только для поиска, по той же причине,
  /// что и у материала: SQLite не умеет снимать регистр с кириллицы.
  TextColumn get nameLower => text()();

  /// `draft` | `saved` | `sent`.
  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Когда таблица и PDF легли на устройство. Любая правка обнуляет отметку
  /// вместе со статусом: файлы после неё описывают не то, что в заявке.
  DateTimeColumn get savedAt => dateTime().nullable()();

  DateTimeColumn get sentAt => dateTime().nullable()();

  /// `xlsx` | `pdf` | `xlsx_pdf` — чем отправляли в прошлый раз.
  TextColumn get lastSentFormat => text().nullable()();
}
