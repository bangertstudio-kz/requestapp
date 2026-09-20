import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/database/app_database.dart';
import 'package:request/core/database/tables/units.dart';
import 'package:request/feature/catalog/data/datasources/unit_mapping.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

void main() {
  test('словарь единиц и перечисление идут в одном порядке', () {
    // Связь держится на порядке: добавленная в середину [ItemUnit] строка
    // сдвинула бы идентификаторы, и метры стали бы штуками во всей базе.
    expect(unitCodes, hasLength(ItemUnit.values.length));
    for (final unit in ItemUnit.values) {
      expect(unitFromId(unitIdOf(unit)), unit);
    }
  });

  test('единицы засеваются при создании базы, id совпадают с порядком', () async {
    final db = AppDatabase.executor(NativeDatabase.memory());
    addTearDown(db.close);

    final rows = await (db.select(db.units)
          ..orderBy([(u) => OrderingTerm(expression: u.id)]))
        .get();

    expect(rows.map((row) => row.code), unitCodes);
    for (final unit in ItemUnit.values) {
      expect(rows[unit.index].id, unitIdOf(unit));
    }
  });
}
