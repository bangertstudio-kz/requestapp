import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/categories.dart';
import 'tables/folders.dart';
import 'tables/items.dart';
import 'tables/request_items.dart';
import 'tables/requests.dart';
import 'tables/units.dart';

part 'app_database.g.dart';

/// Локальное хранилище приложения: справочник и заявки в одной базе.
///
/// Одна база, а не две по фиче: позиция заявки ссылается на материал
/// справочника, и внешний ключ через границу файлов SQLite не проходит —
/// пришлось бы вычищать висящие ссылки руками при каждом удалении.
@DriftDatabase(
  tables: [Units, Categories, Items, Folders, Requests, RequestItems],
)
class AppDatabase extends _$AppDatabase {
  /// Боевая база на устройстве.
  AppDatabase() : super(driftDatabase(name: _fileName));

  /// База для тестов: `AppDatabase.executor(NativeDatabase.memory())`.
  /// Отдельный конструктор, а не nullable-аргумент, чтобы в боевом коде
  /// нельзя было случайно передать `null` и получить базу в памяти.
  AppDatabase.executor(super.executor) : super();

  static const _fileName = 'request';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedUnits();
    },
    beforeOpen: (details) async {
      // Без этого `ON DELETE SET NULL` и каскады не работают: SQLite
      // выключает внешние ключи по умолчанию, и позиция удалённой заявки
      // осталась бы висеть с ссылкой в никуда.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Единицы засеваются один раз при создании базы и дальше не меняются:
  /// это словарь прайса, а не пользовательские данные.
  Future<void> _seedUnits() => batch(
    (batch) => batch.insertAll(units, [
      for (final code in unitCodes) UnitsCompanion.insert(code: code),
    ]),
  );
}
