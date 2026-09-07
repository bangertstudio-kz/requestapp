// Разбор адресов в маршруты, включая deep link на экран заявки без
// предзагруженной модели — то, ради чего деталь принимает nullable-модель
// и обязательный id.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:request/core/dependencies/container/mock_dependency_factory.dart';
import 'package:request/core/navigation/app_routes.dart';
import 'package:request/feature/catalog/presentation/catalog_import_page.dart';
import 'package:request/feature/catalog/presentation/catalog_page.dart';
import 'package:request/feature/catalog/presentation/material_pick_page.dart';
import 'package:request/feature/catalog/presentation/subcategory_page.dart';
import 'package:request/feature/requests/presentation/request_detail_page.dart';
import 'package:request/feature/requests/presentation/request_item_page.dart';
import 'package:request/feature/requests/presentation/requests_page.dart';
import 'package:request/main.dart';

/// Моки отвечают с задержкой; `pumpAndSettle` на живых анимациях зависает.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

Future<GoRouter> _launch(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 892) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final container = await const MockRootFactory().create();
  await tester.pumpWidget(App(container: container));
  await _settle(tester);
  return GoRouter.of(tester.element(find.byType(RequestsPage)));
}

void main() {
  test('маршруты собирают ожидаемые адреса', () {
    expect(const RequestsRoute().location, '/requests');
    expect(
      const FolderRequestsRoute(folderId: 'f1').location,
      '/requests/folder/f1',
    );
    expect(
      const RequestDetailRoute(requestId: 'r1').location,
      '/requests/detail/r1',
    );
    expect(
      const RequestItemRoute(requestId: 'r1', itemId: 'r1-2').location,
      '/requests/detail/r1/item/r1-2',
    );
    expect(
      const SubcategoryRoute(categoryId: 'c1', subcategoryId: 'c1-s1')
          .location,
      '/catalog/category/c1/subcategory/c1-s1',
    );
  });

  testWidgets('deep link на заявку грузит её по id', (tester) async {
    final router = await _launch(tester);

    router.go('/requests/detail/r1');
    await _settle(tester);

    expect(find.byType(RequestDetailPage), findsOneWidget);
    // Модель не приезжала: по ссылке приходят без неё, и экран обязан
    // загрузить заявку сам, а не отправить пользователя в список.
    final page = tester.widget<RequestDetailPage>(
      find.byType(RequestDetailPage),
    );
    expect(page.request, isNull);
    expect(find.text('ЖК Северный, стояки Б2'), findsWidgets);
  });

  testWidgets('deep link на позицию и подбор материала', (tester) async {
    final router = await _launch(tester);

    router.go('/requests/detail/r1/item/r1-2');
    await _settle(tester);
    expect(find.byType(RequestItemPage), findsOneWidget);
    expect(find.text('Отвод ⌀100'), findsOneWidget);

    router.go('/requests/detail/r1/pick?replace-item-id=r1-2');
    await _settle(tester);
    final pick = tester.widget<MaterialPickPage>(
      find.byType(MaterialPickPage),
    );
    expect(pick.requestId, 'r1');
    expect(pick.replaceItemId, 'r1-2');
  });

  testWidgets('deep link в справочник', (tester) async {
    final router = await _launch(tester);

    router.go('/catalog');
    await _settle(tester);
    expect(find.byType(CatalogPage), findsOneWidget);

    router.go('/catalog/category/c1/subcategory/c1-s1');
    await _settle(tester);
    expect(find.byType(SubcategoryPage), findsOneWidget);
    expect(find.text('Труба'), findsWidgets);

    router.go('/catalog/import');
    await _settle(tester);
    expect(find.byType(CatalogImportPage), findsOneWidget);
  });

  testWidgets('ни один экран не остаётся прозрачным', (tester) async {
    final router = await _launch(tester);

    // Прозрачный `Scaffold` внутри маршрута — это чёрный экран на устройстве:
    // за маршрутом ничего не нарисовано. В golden-PNG прозрачность выглядит
    // белой, поэтому баг живёт до первого запуска на телефоне.
    const routes = [
      '/requests',
      '/requests/folder/f1',
      '/requests/new-folder',
      '/requests/detail/r1',
      '/requests/detail/r1/item/r1-1',
      '/requests/detail/r1/pick',
      '/catalog',
      '/catalog/import',
      '/catalog/category-form',
      '/catalog/subcategory-form?category-id=c1',
      '/catalog/material-form',
      '/catalog/material-form?material-id=c1-s1-m1',
      '/catalog/category/c1',
      '/catalog/category/c1/subcategory/c1-s1',
    ];

    for (final location in routes) {
      router.go(location);
      await _settle(tester);

      final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
      expect(scaffolds, isNotEmpty, reason: '$location: нет Scaffold');
      for (final scaffold in scaffolds) {
        expect(
          scaffold.backgroundColor,
          isNot(Colors.transparent),
          reason: '$location: прозрачный фон экрана',
        );
      }
    }
  });

  testWidgets('несуществующий адрес показывает свой экран', (tester) async {
    final router = await _launch(tester);

    router.go('/requests/detail');
    await _settle(tester);
    expect(find.text('К заявкам'), findsOneWidget);
  });
}
