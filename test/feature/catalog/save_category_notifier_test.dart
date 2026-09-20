import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/presentation/request_notifier.dart';
import 'package:request/feature/catalog/data/mock_catalog_repository.dart';
import 'package:request/feature/catalog/domain/entities/catalog_params.dart';
import 'package:request/feature/catalog/presentation/save_category_notifier.dart';

void main() {
  test('выбранная родительская категория доезжает до хранилища', () async {
    // Нотифаер звал saveCategory без parentId. Параметр необязательный,
    // поэтому компилятор молчал, а категория всякий раз создавалась
    // на верхнем уровне — ровно то, от чего человек её уводил.
    final repository = MockCatalogRepository();
    final notifier = SaveCategoryNotifier(repository);
    final root = (await repository.categories()).first;

    await notifier.run(
      const SaveCategoryParams(name: 'Чугунная'),
    );
    await notifier.run(
      SaveCategoryParams(name: 'Пластиковая', parentId: root.id),
    );

    final after = await repository.categories();
    // Без родителя — на верхнем уровне.
    expect(after.map((c) => c.name), contains('Чугунная'));
    // С родителем — внутри него, а не рядом.
    expect(after.map((c) => c.name), isNot(contains('Пластиковая')));
    expect(
      after.firstWhere((c) => c.id == root.id).categories.map((c) => c.name),
      contains('Пластиковая'),
    );
  });
}
