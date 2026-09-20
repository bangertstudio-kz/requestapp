import 'package:drift/drift.dart';

import 'items.dart';
import 'requests.dart';

/// Позиция заявки: ссылка на материал и количество.
///
/// `itemId` обнуляется, а не удаляет позицию: материал убрали из справочника,
/// но отправленная заявка остаётся документом, и строка в ней должна
/// сохранить количество и своё место. Название такой позиции экран берёт
/// из подписи «материал удалён» — показывать нечего, а терять нечего тем более.
@TableIndex(name: 'request_item_request', columns: {#requestId})
@TableIndex(name: 'request_item_item', columns: {#itemId})
@DataClassName('RequestItemRow')
class RequestItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get requestId =>
      integer().references(Requests, #id, onDelete: KeyAction.cascade)();

  IntColumn get itemId => integer()
      .nullable()
      .references(Items, #id, onDelete: KeyAction.setNull)();

  /// Только целые: половину трубы со склада не выдают.
  IntColumn get quantity => integer()();

  /// Порядок позиций в заявке. Задаётся при записи по порядку в списке:
  /// человек добавляет материалы в том порядке, в каком обходит стояк,
  /// и сортировка по имени перемешала бы обход.
  IntColumn get position => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
