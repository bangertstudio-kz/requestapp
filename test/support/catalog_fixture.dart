import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/catalog_item.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

/// Маленькое дерево вместо настоящего прайса: тест на 326 позиций проверяет
/// то же самое, но падает с непечатаемым сообщением.
///
/// Три уровня и материалы не только в листьях — то, чего двухуровневая
/// модель не допускала и что теперь надо проверять.
///
/// Идентификаторы здесь ни на что не влияют — хранилище раздаёт свои при
/// записи; в дереве они стоят, потому что их требует сущность.
List<CatalogCategory> catalogFixture() => [
  CatalogCategory(
    id: 'c1',
    name: 'Канализация',
    categories: [
      CatalogCategory(
        id: 'c1-s1',
        name: 'Труба',
        categories: [
          CatalogCategory(
            id: 'c1-s1-s1',
            name: 'Чугунная',
            items: [_item('Труба ⌀100/2000', ItemUnit.piece)],
          ),
        ],
        // Материал рядом с вложенной веткой: раньше так было нельзя.
        items: [_item('Труба ⌀100/3000', ItemUnit.piece)],
      ),
      CatalogCategory(
        id: 'c1-s2',
        name: 'Отвод',
        items: [_item('Отвод ⌀100', ItemUnit.piece)],
      ),
    ],
  ),
  CatalogCategory(
    id: 'c2',
    name: 'ППР',
    categories: [
      CatalogCategory(
        id: 'c2-s1',
        name: 'Труба',
        items: [_item('Труба ⌀25', ItemUnit.meter)],
      ),
      // Пустая ветка: в неё добавляют материалы, и она обязана приезжать.
      const CatalogCategory(id: 'c2-s2', name: 'Кран'),
    ],
  ),
  // Категория верхнего уровня с материалом и без вложенных — «Расходный
  // материал» из прайса выглядит именно так.
  CatalogCategory(
    id: 'c3',
    name: 'Расходный материал',
    items: [_item('Саморез по дереву 41', ItemUnit.piece)],
  ),
];

CatalogItem _item(String name, ItemUnit unit) =>
    CatalogItem(id: name, name: name, unit: unit);
