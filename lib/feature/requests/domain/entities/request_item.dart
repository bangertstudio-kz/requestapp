import '../../../catalog/domain/entities/material_unit.dart';

/// Позиция заявки: материал и количество.
///
/// Название, путь и единица скопированы из справочника, а не взяты по ссылке:
/// заявка — документ на момент отправки, и переименование материала в
/// справочнике не должно менять то, что уже отправлено поставщику.
class RequestItem {
  const RequestItem({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.subcategoryName,
    required this.quantity,
    required this.unit,
  });

  final String id;
  final String name;
  final String categoryName;
  final String subcategoryName;

  /// Только целые: половину трубы со склада не выдают.
  final int quantity;

  final MaterialUnit unit;
}

/// Правка количества как операция над позицией.
extension RequestItemQuantity on RequestItem {
  RequestItem withQuantity(int value) => RequestItem(
    id: id,
    name: name,
    categoryName: categoryName,
    subcategoryName: subcategoryName,
    quantity: value,
    unit: unit,
  );
}
