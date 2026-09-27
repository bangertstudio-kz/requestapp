// Регрессии на правку справочника: оба случая ловились только запуском.
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/mock_catalog_repository.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/item_draft.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';

CatalogCategory _byName(List<CatalogCategory> all, String name) =>
    all.firstWhere((item) => item.name == name);

void main() {
  test('правка материала не меняет его место в списке', () async {
    final repository = MockCatalogRepository();
    final before = await repository.categories();
    final pipes = _byName(before, 'Канализация').categories.first; // «Труба»
    final target = pipes.items[3];
    final position = pipes.items.indexOf(target);

    await repository.saveItem(
      ItemDraft(
        id: target.id,
        name: '${target.name} (уточнён)',
        categoryId: pipes.id,
        unit: target.unit,
      ),
    );

    final after = await repository.categories();
    final updated = _byName(after, 'Канализация').categories.first.items;
    // Раньше правка удаляла запись и дописывала её в конец: человек,
    // поправивший опечатку, искал материал заново среди тринадцати труб.
    expect(updated[position].id, target.id);
    expect(updated[position].name, '${target.name} (уточнён)');
    expect(updated.length, pipes.items.length);
  });

  test('перестановка материалов меняет только их порядок', () async {
    final repository = MockCatalogRepository();
    final pipes = _byName(await repository.categories(), 'Канализация')
        .categories
        .first;
    final reversed = [for (final item in pipes.items.reversed) item.id];

    await repository.reorderItems(pipes.id, reversed);

    final after = _byName(await repository.categories(), 'Канализация')
        .categories
        .first;
    expect([for (final item in after.items) item.id], reversed);
  });

  test('перенос материала в другую категорию убирает его из старой', () async {
    final repository = MockCatalogRepository();
    final before = await repository.categories();
    final category = _byName(before, 'Канализация');
    final from = category.categories[0];
    final to = category.categories[1];
    final item = from.items.first;

    await repository.saveItem(
      ItemDraft(
        id: item.id,
        name: item.name,
        categoryId: to.id,
        unit: item.unit,
      ),
    );

    final after = _byName(await repository.categories(), 'Канализация');
    expect(after.categories[0].items.any((m) => m.id == item.id), isFalse);
    final moved = after.categories[1].items.firstWhere((m) => m.id == item.id);
    // Путь пересобирается вместе с переносом: он показывается в карточке
    // позиции без обхода дерева.
    expect(moved.path, [category.name, to.name]);
  });

  test('материал можно положить прямо в корневую категорию', () async {
    final repository = MockCatalogRepository();
    final root = (await repository.categories()).first;

    await repository.saveItem(
      ItemDraft(
        id: null,
        name: 'Труба без раздела',
        categoryId: root.id,
        unit: ItemUnit.piece,
      ),
    );

    final after = (await repository.categories()).first;
    final added = after.items.firstWhere((m) => m.name == 'Труба без раздела');
    // Путь из одного звена — законное состояние с тех пор, как материалы
    // лежат в категории любого уровня.
    expect(added.path, [root.name]);
  });

  test('категория не уходит внутрь собственного потомка', () async {
    final repository = MockCatalogRepository();
    final root = (await repository.categories()).first;
    final child = root.categories.first;

    await expectLater(
      repository.saveCategory(
        id: root.id,
        name: root.name,
        parentId: child.id,
      ),
      throwsA(isA<DescribedException>()),
    );
    expect((await repository.categories()).first.id, root.id);
  });

  test('несуществующая категория — отказ, а не запись с пустым путём',
      () async {
    final repository = MockCatalogRepository();

    expect(
      () => repository.saveItem(
        const ItemDraft(
          id: null,
          name: 'Труба ниоткуда',
          categoryId: 'нет-такой',
          unit: ItemUnit.piece,
        ),
      ),
      throwsA(isA<DescribedException>()),
    );
  });
}
