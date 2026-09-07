import 'material_unit.dart';

/// Материал справочника.
///
/// Имя `CatalogMaterial`, а не `Material`: последнее занято виджетом Flutter,
/// и импорт-конфликт в каждом экране дороже пяти лишних букв.
class CatalogMaterial {
  const CatalogMaterial({
    required this.id,
    required this.name,
    required this.unit,
    required this.categoryName,
    required this.subcategoryName,
  });

  final String id;
  final String name;

  /// Единица приходит из справочника и в заявке не редактируется: одна и та
  /// же труба не может считаться в штуках у одного прораба и в метрах у другого.
  final MaterialUnit unit;

  /// Путь до материала хранится строками, а не ссылками на категории: карточка
  /// в списке должна показать путь, не поднимая весь справочник.
  final String categoryName;
  final String subcategoryName;
}
