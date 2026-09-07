import 'material_unit.dart';

/// Заготовка материала справочника: то, что заполняет форма.
///
/// Отдельно от [CatalogMaterial], потому что у черновика ещё нет
/// идентификатора, а место в дереве задано ссылками, а не названиями:
/// форма выбирает категорию, а не печатает её имя.
class MaterialDraft {
  const MaterialDraft({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.unit,
  });

  /// `null` — новая запись. Правка переносит материал в другую подкатегорию
  /// тем же сохранением: в форме это один и тот же набор полей.
  final String? id;

  final String name;
  final String categoryId;
  final String subcategoryId;
  final MaterialUnit unit;
}
