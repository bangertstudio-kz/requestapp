import 'item_unit.dart';

/// Заготовка материала справочника: то, что заполняет форма.
///
/// Отдельно от [CatalogItem], потому что у черновика ещё нет идентификатора,
/// а место в дереве задано ссылкой, а не названиями: форма выбирает
/// категорию, а не печатает её имя.
class ItemDraft {
  const ItemDraft({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.unit,
  });

  /// `null` — новая запись. Правка переносит материал в другую категорию
  /// тем же сохранением: в форме это один и тот же набор полей.
  final String? id;

  final String name;

  /// Категория любого уровня — материал может лежать и в корневой.
  final String categoryId;

  final ItemUnit unit;
}
