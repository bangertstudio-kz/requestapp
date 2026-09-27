import '../../../catalog/domain/entities/item_unit.dart';

/// Позиция заявки: материал и количество.
///
/// Название, путь и единица скопированы из справочника, а не взяты по ссылке:
/// заявка — документ на момент отправки, и переименование материала в
/// справочнике не должно менять то, что уже отправлено поставщику.
class RequestItem {
  const RequestItem({
    required this.id,
    this.itemId,
    required this.name,
    required this.path,
    required this.quantity,
    required this.unit,
  });

  final String id;

  /// Материал справочника, из которого позиция взята. `null` — материал
  /// оттуда удалили: заявка остаётся документом и теряет только ссылку,
  /// а не количество и не своё место в списке.
  ///
  /// Отдельно от [id]: подбор больше не заводит вторую позицию того же
  /// материала — он предлагает прибавить или заменить количество, — но в
  /// заявках, собранных раньше, такие пары остались, и у них разные [id].
  final String? itemId;

  final String name;

  /// Путь до материала на момент добавления — названия категорий от корня.
  ///
  /// Список, а не пара строк: справочник — дерево любой глубины. Снимок,
  /// а не ссылка, по той же причине, что и название: заявка — документ
  /// на момент отправки.
  final List<String> path;

  /// Только целые: половину трубы со склада не выдают.
  final int quantity;

  final ItemUnit unit;
}

/// Правка количества как операция над позицией.
extension RequestItemQuantity on RequestItem {
  RequestItem withQuantity(int value) => RequestItem(
    id: id,
    itemId: itemId,
    name: name,
    path: path,
    quantity: value,
    unit: unit,
  );
}
