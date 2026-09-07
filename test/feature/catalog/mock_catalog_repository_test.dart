// Регрессии на правку справочника: оба случая ловились только запуском.
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/domain/described_exception.dart';
import 'package:request/feature/catalog/data/mock_catalog_repository.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/material_draft.dart';
import 'package:request/feature/catalog/domain/entities/material_unit.dart';

CatalogCategory _byName(List<CatalogCategory> all, String name) =>
    all.firstWhere((item) => item.name == name);

void main() {
  test('правка материала не меняет его место в списке', () async {
    final repository = MockCatalogRepository();
    final before = await repository.categories();
    final subcategory =
        _byName(before, 'Канализация').subcategories.first; // «Труба»
    final target = subcategory.materials[3];
    final position = subcategory.materials.indexOf(target);

    await repository.saveMaterial(
      MaterialDraft(
        id: target.id,
        name: '${target.name} (уточнён)',
        categoryId: _byName(before, 'Канализация').id,
        subcategoryId: subcategory.id,
        unit: target.unit,
      ),
    );

    final after = await repository.categories();
    final updated =
        _byName(after, 'Канализация').subcategories.first.materials;
    // Раньше правка удаляла запись и дописывала её в конец: человек,
    // поправивший опечатку, искал материал заново среди тринадцати труб.
    expect(updated[position].id, target.id);
    expect(updated[position].name, '${target.name} (уточнён)');
    expect(updated.length, subcategory.materials.length);
  });

  test('перенос материала в другую подкатегорию убирает его из старой',
      () async {
    final repository = MockCatalogRepository();
    final before = await repository.categories();
    final category = _byName(before, 'Канализация');
    final from = category.subcategories[0];
    final to = category.subcategories[1];
    final material = from.materials.first;

    await repository.saveMaterial(
      MaterialDraft(
        id: material.id,
        name: material.name,
        categoryId: category.id,
        subcategoryId: to.id,
        unit: material.unit,
      ),
    );

    final after = _byName(await repository.categories(), 'Канализация');
    expect(
      after.subcategories[0].materials.any((m) => m.id == material.id),
      isFalse,
    );
    final moved =
        after.subcategories[1].materials.firstWhere((m) => m.id == material.id);
    // Путь переписывается вместе с переносом: он хранится строкой и
    // показывается в карточке позиции без обхода дерева.
    expect(moved.subcategoryName, to.name);
  });

  test('несуществующая подкатегория — отказ, а не запись с пустым путём',
      () async {
    final repository = MockCatalogRepository();
    final categories = await repository.categories();

    expect(
      () => repository.saveMaterial(
        MaterialDraft(
          id: null,
          name: 'Труба ниоткуда',
          categoryId: categories.first.id,
          subcategoryId: 'нет-такой',
          unit: MaterialUnit.piece,
        ),
      ),
      throwsA(isA<DescribedException>()),
    );
  });
}
