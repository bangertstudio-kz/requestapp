// Временная проверка вёрстки: рендерим каждый экран и ловим overflow.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/widgets/confirm_sheet.dart';
import 'package:request/core/widgets/name_form_screen.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/catalog_import_summary.dart';
import 'package:request/feature/catalog/domain/entities/catalog_item.dart';
import 'package:request/feature/catalog/domain/entities/item_unit.dart';
import 'package:request/feature/catalog/presentation/catalog_import_screen.dart';
import 'package:request/feature/catalog/presentation/catalog_list_screen.dart';
import 'package:request/feature/catalog/presentation/catalog_row.dart';
import 'package:request/feature/catalog/presentation/category_pick_sheet.dart';
import 'package:request/feature/catalog/presentation/item_form_screen.dart';
import 'package:request/feature/catalog/presentation/item_pick_screen.dart';
import 'package:request/feature/catalog/presentation/quantity_controller.dart';
import 'package:request/feature/requests/domain/entities/material_request.dart';
import 'package:request/feature/requests/domain/entities/request_filter.dart';
import 'package:request/feature/requests/domain/entities/request_folder.dart';
import 'package:request/feature/requests/domain/entities/request_item.dart';
import 'package:request/feature/requests/domain/entities/request_status.dart';
import 'package:request/feature/requests/presentation/request_detail_screen.dart';
import 'package:request/feature/requests/domain/entities/request_document.dart';
import 'package:request/feature/requests/data/request_xlsx.dart';
import 'package:request/feature/requests/presentation/request_item_screen.dart';
import 'package:request/feature/requests/presentation/request_preview_screen.dart';
import 'package:request/feature/requests/presentation/requests_screen.dart';
import 'package:request/feature/requests/presentation/send_request_sheet.dart';
import 'package:request/generated/app_localizations.dart';
import 'package:request/core/dependencies/container/mock_dependency_factory.dart';
import 'package:request/main.dart';
import 'package:request_ui/request_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _catalogItem = CatalogItem(
  id: 'm1',
  name: 'Труба ⌀100/2000',
  unit: ItemUnit.piece,
  path: ['Канализация', 'Труба'],
);

final _categories = [
  CatalogCategory(
    id: 'c1',
    name: 'Канализация',
    categories: [
      CatalogCategory(id: 's1', name: 'Труба', parentId: 'c1', items: [_catalogItem]),
      const CatalogCategory(id: 's2', name: 'Отвод', parentId: 'c1'),
    ],
  ),
  const CatalogCategory(id: 'c2', name: 'ППР'),
];

const _item = RequestItem(
  id: 'i1',
  itemId: 'm1',
  name: 'Труба ⌀100/2000',
  path: ['Канализация', 'Труба'],
  quantity: 24,
  unit: ItemUnit.piece,
);

final _request = MaterialRequest(
  id: 'r1',
  name: 'ЖК Северный, стояки Б2',
  createdAt: DateTime(2026, 9, 4),
  status: RequestStatus.draft,
  folderId: 'f1',
  items: [_item, _item],
);

// Строковые фикстуры вынесены в константы: плагин markup_analyzer запрещает
// литералы в конструкторах виджетов, и в тесте это правило работает так же.
const _catalogTitle = 'Справочник';
const _catalogSubtitle = 'Категории, подкатегории и материалы';
const _catalogLabel = 'Категории · 2';
const _catalogRowMeta = '13 подкат. · Труба, Отвод, Тройник';
const _catalogFab = 'Категория';
const _catalogEmpty = 'В справочнике нет категорий.';
const _folderTitle = 'Папка';
const _itemName = 'Труба ⌀100/2000';
const _folderName = 'Котельные';
const _categoryPath = 'Канализация → Труба';
const _parentLabel = 'Внутри';
const _importTarget = 'Канализация';
const _importApply = 'Добавить в справочник';
const _pickedCategoryId = 'c1';
const _previewFileName = 'zayavka-2026-09-04.xlsx';
const _confirmTitle = 'Удалить заявку?';
const _confirmMessage = 'Заявка «ЖК Северный» и все её 4 позиций будут удалены.';
const _confirmAction = 'Удалить';
const _importFile = 'Прайс сантехника-SergeyM 2.xlsx';
const _importError = 'Не удалось прочитать файл.';

/// Экраны проверяются по-русски: локаль теста по умолчанию — английская,
/// а строки в проверках — из `ru.arb`.
Widget _host(Widget child) => MaterialApp(
      locale: const Locale('ru'),
      theme: RequestTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

Future<void> _render(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(412, 892),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_host(child));
  await tester.pump(const Duration(milliseconds: 300));
}

/// Моки отвечают с задержкой, а на экранах живут бесконечные анимации —
/// `pumpAndSettle` на таком зависает. Серия кадров надёжнее.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  testWidgets('requests screen', (tester) async {
    await _render(
      tester,
      RequestsScreen(
        requests: [_request],
        totalCount: 3,
        folders: const [
          RequestFolder(id: 'f1', name: 'ЖК Северный', requestCount: 2),
          RequestFolder(id: 'f2', name: 'Котельные', requestCount: 1),
        ],
        folder: null,
        filter: RequestFilter.all,
        searchController: TextEditingController(),
        onSearchChanged: (_) {},
        onFilterSelected: (_) {},
        onFolderOpened: (_) {},
        onFolderCreate: () {},
        onRequestOpened: (_) {},
        onRequestCreate: () {},
      ),
    );
    expect(find.text('ЖК Северный, стояки Б2'), findsOneWidget);
    expect(find.text('Черновик'), findsOneWidget);
  });

  testWidgets('requests screen: empty', (tester) async {
    await _render(
      tester,
      RequestsScreen(
        requests: const [],
        totalCount: 0,
        folders: const [],
        folder: null,
        filter: RequestFilter.drafts,
        searchController: TextEditingController(),
        onSearchChanged: (_) {},
        onFilterSelected: (_) {},
        onFolderOpened: (_) {},
        onFolderCreate: () {},
        onRequestOpened: (_) {},
        onRequestCreate: () {},
      ),
    );
    expect(find.textContaining('Ничего не найдено'), findsOneWidget);
  });

  testWidgets('request detail', (tester) async {
    await _render(
      tester,
      RequestDetailScreen(
        folderName: _folderName,
        onChangeFolder: () {},
        request: _request,
        nameController: TextEditingController(text: _request.name),
        onNameChanged: (_) {},
        onAddItem: () {},
        onItemOpened: (_) {},
        onItemIncrement: (_) {},
        onItemDecrement: (_) {},
        onItemRemove: (_) {},
        onSave: () {},
        onSend: () {},
        onDelete: () {},
        onBack: () {},
      ),
    );
    expect(find.text('Добавить материал'), findsOneWidget);
    expect(find.text('24'), findsNWidgets(2));
  });

  testWidgets('category pick: длинный список прокручивается', (tester) async {
    // Полсотни категорий — обычный размер прайса заказчика. Раньше шторка
    // отдавала списку неограниченную высоту: список не прокручивался,
    // а переполнял её. В ограниченной высоте это видно как overflow,
    // на который тест и падает.
    final options = [
      for (var index = 1; index <= 50; index++)
        (
          category: CatalogCategory(id: 'c$index', name: 'Категория $index'),
          path: <String>['Категория $index'],
        ),
    ];

    await _render(
      tester,
      Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          // Столько высоты шторке оставляет showModalBottomSheet.
          height: 360,
          child: CategoryPickSheet(
            options: options,
            selectedId: _pickedCategoryId,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    final before = tester.getTopLeft(find.text('Категория 1')).dy;
    await tester.drag(find.text('Категория 3'), const Offset(0, -600));
    await tester.pump();

    // Список уехал вверх — значит прокрутился, а не обрезался.
    expect(tester.getTopLeft(find.text('Категория 1')).dy, lessThan(before));
    // Заголовок остаётся на месте: он вне прокручиваемой части.
    expect(find.text(_parentLabel), findsOneWidget);
  });

  testWidgets('request preview: excel', (tester) async {
    // Экран читает настоящую книгу — ту, что собрал бы для отправки. PDF
    // здесь не проверяем: его отрисовка идёт через плагин печати, которого
    // в тестовом окружении нет.
    tester.view.physicalSize = const Size(412, 892) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        _host(
          RequestPreviewScreen(
            requestName: _request.name,
            documents: [
              RequestDocument(
                format: DocumentFormat.xlsx,
                name: _previewFileName,
                bytes: Uint8List.fromList(requestToXlsx(_request)),
              ),
            ],
            onShare: () {},
            onBack: () {},
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });

    await _settle(tester);

    expect(find.text(_previewFileName), findsOneWidget);
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
      reason: 'книга должна быть прочитана',
    );
    // В заявке-образце две позиции с одним материалом — в книге тоже две.
    expect(find.text(_itemName), findsNWidgets(_request.items.length));
  });

  testWidgets('request item', (tester) async {
    await _render(
      tester,
      RequestItemScreen(
        item: _item,
        requestName: _request.name,
        quantityController: QuantityController.fromQuantity(24),
        onReplaceItem: () {},
        onSave: () {},
        onDelete: () {},
        onBack: () {},
      ),
    );
    expect(find.text('Заменить материал'), findsOneWidget);
  });

  testWidgets('item pick: tree', (tester) async {
    await _render(
      tester,
      ItemPickScreen(
        categories: _categories,
        searchResults: null,
        searchLoading: false,
        searchController: TextEditingController(),
        onSearchChanged: (_) {},
        selected: null,
        onSelected: (_) {},
        onSelectionCleared: () {},
        quantityController: QuantityController(),
        onAdd: (_, _) {},
        onBack: () {},
      ),
    );
    // Дерево открывается свёрнутым: подкатегорий не видно до нажатия.
    expect(find.text('Канализация'), findsOneWidget);
    expect(find.text('Труба'), findsNothing);
  });

  testWidgets('item pick: selected shows sheet', (tester) async {
    await _render(
      tester,
      ItemPickScreen(
        categories: _categories,
        searchResults: [_catalogItem],
        searchLoading: false,
        searchController: TextEditingController(text: 'труба'),
        onSearchChanged: (_) {},
        selected: _catalogItem,
        onSelected: (_) {},
        onSelectionCleared: () {},
        quantityController: QuantityController.fromQuantity(12),
        onAdd: (_, _) {},
        onBack: () {},
      ),
    );
    expect(find.text('Добавить в заявку'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('catalog root', (tester) async {
    await _render(
      tester,
      CatalogListScreen(
        title: _catalogTitle,
        subtitle: _catalogSubtitle,
        label: _catalogLabel,
        tab: CatalogTab.categories,
        onTabSelected: (_) {},
        itemCount: _categories.length,
        itemBuilder: (context, index) => CatalogRow(
          name: _categories[index].name,
          meta: _catalogRowMeta,
          onOpen: () {},
          onEdit: () {},
          onRemove: () {},
        ),
        emptyMessage: _catalogEmpty,
        fabLabel: _catalogFab,
        onFabPressed: () {},
      ),
    );
    expect(find.text('Изм.'), findsNWidgets(2));
  });

  testWidgets('category: материалы переставляются за ручку', (tester) async {
    var order = ['Отвод ⌀50', 'Отвод ⌀100', 'Отвод ⌀110'];
    (int, int)? reordered;
    await _render(
      tester,
      StatefulBuilder(
        builder: (context, setState) => CatalogListScreen(
          title: _catalogTitle,
          subtitle: _catalogSubtitle,
          label: _catalogLabel,
          // Одна вложенная ветка сверху — она не перетаскивается.
          itemCount: 1 + order.length,
          reorderFrom: 1,
          onReorder: (oldIndex, newIndex) => setState(() {
            reordered = (oldIndex, newIndex);
            final next = [...order];
            order = next..insert(newIndex, next.removeAt(oldIndex));
          }),
          itemBuilder: (context, index) => index == 0
              ? CatalogRow(
                  name: _categories.first.name,
                  meta: _catalogRowMeta,
                  onOpen: () {},
                  onEdit: () {},
                  onRemove: () {},
                )
              : CatalogRow(
                  key: ValueKey(order[index - 1]),
                  dragIndex: index - 1,
                  name: order[index - 1],
                  meta: _catalogRowMeta,
                  onOpen: () {},
                  onEdit: () {},
                  onRemove: () {},
                ),
          emptyMessage: _catalogEmpty,
          fabLabel: _catalogFab,
          onFabPressed: () {},
        ),
      ),
    );
    // Ручки только у материалов.
    expect(find.byIcon(Icons.drag_indicator), findsNWidgets(3));

    final gesture = await tester.startGesture(
      tester.getCenter(find.byIcon(Icons.drag_indicator).first),
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await _settle(tester);

    expect(reordered?.$1, 0);
    expect(reordered?.$2, 2);
    expect(order, ['Отвод ⌀100', 'Отвод ⌀110', 'Отвод ⌀50']);
  });

  testWidgets('name form', (tester) async {
    await _render(
      tester,
      NameFormScreen(
        title: _folderTitle,
        editing: false,
        controller: TextEditingController(),
        formKey: GlobalKey<FormState>(),
        onSave: () {},
        onCancel: () {},
      ),
    );
    expect(find.text('Новая запись'), findsOneWidget);
  });

  testWidgets('item form', (tester) async {
    await _render(
      tester,
      ItemFormScreen(
        editing: true,
        categoryLabel: _categoryPath,
        selectedUnit: ItemUnit.meter,
        nameController: TextEditingController(text: _itemName),
        formKey: GlobalKey<FormState>(),
        onCategoryTap: () {},
        onUnitSelected: (_) {},
        onSave: () {},
        onCancel: () {},
      ),
    );
    expect(find.text('комплект'), findsOneWidget);
  });

  testWidgets('sheets', (tester) async {
    await _render(
      tester,
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConfirmSheet(
              title: _confirmTitle,
              message: _confirmMessage,
              confirmLabel: _confirmAction,
              onConfirm: () {},
              onCancel: () {},
            ),
          ],
        ),
      ),
    );
    expect(find.text('Отмена'), findsOneWidget);

    await _render(
      tester,
      Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SendRequestSheet(onSelected: (_) {}, onCancel: () {}),
          ],
        ),
      ),
    );
    expect(find.text('Excel и PDF'), findsOneWidget);
  });

  testWidgets('catalog import: all states', (tester) async {
    await _render(
      tester,
      CatalogImportScreen(
        targetLabel: _importTarget,
        targetIsRoot: false,
        onPickTarget: () {},
        onPickRoot: () {},
        onCopyPrompt: () {},
        summary: null,
        parsing: false,
        errorMessage: null,
        onPickFile: () {},
        onApply: () {},
        onBack: () {},
      ),
    );
    expect(find.text('Выбрать файл'), findsOneWidget);

    await _render(
      tester,
      CatalogImportScreen(
        targetLabel: _importTarget,
        targetIsRoot: false,
        onPickTarget: () {},
        onPickRoot: () {},
        onCopyPrompt: () {},
        summary: null,
        parsing: true,
        errorMessage: null,
        onPickFile: () {},
        onApply: () {},
        onBack: () {},
      ),
    );
    expect(find.textContaining('Разбираем'), findsOneWidget);

    await _render(
      tester,
      CatalogImportScreen(
        targetLabel: _importTarget,
        targetIsRoot: false,
        onPickTarget: () {},
        onPickRoot: () {},
        onCopyPrompt: () {},
        summary: null,
        parsing: false,
        errorMessage: _importError,
        onPickFile: () {},
        onApply: () {},
        onBack: () {},
      ),
    );
    expect(find.text(_importError), findsOneWidget);

    await _render(
      tester,
      CatalogImportScreen(
        targetLabel: _importTarget,
        targetIsRoot: false,
        onPickTarget: () {},
        onPickRoot: () {},
        onCopyPrompt: () {},
        summary: const CatalogImportSummary(
          fileName: _importFile,
          targetPath: ['Канализация'],
          itemsAdded: 326,
          itemsUpdated: 12,
          categoriesCreated: 51,
          duplicatesRemoved: 6,
          rowsTrimmed: 14,
          rowsSkipped: 2,
          unknownUnits: ['м2'],
        ),
        parsing: false,
        errorMessage: null,
        onPickFile: () {},
        onApply: () {},
        onBack: () {},
      ),
    );
    expect(find.text('326'), findsOneWidget);
    expect(find.text(_importApply), findsOneWidget);
  });

  testWidgets('item pick: nothing found', (tester) async {
    await _render(
      tester,
      ItemPickScreen(
        categories: _categories,
        searchResults: const [],
        searchLoading: false,
        searchController: TextEditingController(text: 'ффф'),
        onSearchChanged: (_) {},
        selected: null,
        onSelected: (_) {},
        onSelectionCleared: () {},
        quantityController: QuantityController(),
        onAdd: (_, _) {},
        onBack: () {},
      ),
    );
    expect(find.textContaining('Ничего не найдено'), findsOneWidget);
  });

  testWidgets('app on mocks: tabs, request, picker', (tester) async {
    tester.view.physicalSize = const Size(412, 892) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final container = await const MockRootFactory().create();
    await tester.pumpWidget(App(container: container));
    await _settle(tester);

    expect(find.text('ЖК Северный, стояки Б2'), findsOneWidget);
    expect(find.text('Создать заявку'), findsOneWidget);

    // Заявка открывается из списка и показывает свои позиции.
    await tester.tap(find.text('ЖК Северный, стояки Б2'));
    await _settle(tester);
    expect(find.text('Труба ⌀100/2000'), findsOneWidget);
    expect(find.text('Добавить материал'), findsOneWidget);

    // Из заявки — в подбор материала, где лежит настоящий справочник.
    await tester.tap(find.text('Добавить материал'));
    await _settle(tester);
    expect(find.text('Поиск по материалам'), findsOneWidget);
    // Категории свёрнуты — ни одна не раскрыта заранее.
    expect(find.text('Канализация'), findsOneWidget);
    expect(find.text('Труба'), findsNothing);

    // Справочник открывается второй вкладкой.
    // Шапка в макете своя, поэтому и «назад» — своя иконка, а не
    // материаловский BackButton, который ищет tester.pageBack().
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new).first);
    await _settle(tester);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new).first);
    await _settle(tester);
    await tester.tap(find.text('Справочник'));
    await _settle(tester);
    expect(find.text('КАТЕГОРИИ · 6'), findsOneWidget);
  });

  testWidgets('подбор: экран остаётся, повторный материал не дублируется', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(412, 892) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final container = await const MockRootFactory().create();
    await tester.pumpWidget(App(container: container));
    await _settle(tester);
    await tester.tap(find.text('ЖК Северный, стояки Б2'));
    await _settle(tester);
    // В заявке на моках четыре позиции.
    expect(find.text('МАТЕРИАЛЫ · 4'), findsOneWidget);
    await tester.tap(find.text('Добавить материал'));
    await _settle(tester);

    Future<void> add(String name, String digit) async {
      await tester.enterText(find.byType(TextField), name);
      await _settle(tester);
      await tester.tap(find.text(name).last);
      await _settle(tester);
      await tester.tap(find.text(digit).last);
      await tester.pump();
      await tester.tap(find.text('Добавить в заявку'));
      await _settle(tester);
    }

    await add('Отвод ⌀30', '2');
    // Шторка закрылась, подбор остался открытым.
    expect(find.text('Добавить в заявку'), findsNothing);
    expect(find.text('Поиск по материалам'), findsOneWidget);
    await add('Отвод ⌀40', '3');

    // Тот же материал ещё раз — шторка выбора вместо второй позиции.
    await add('Отвод ⌀30', '3');
    expect(find.text('Материал уже в заявке'), findsOneWidget);
    // Отмена возвращает к количеству.
    await tester.tap(find.text('Отмена'));
    await _settle(tester);
    expect(find.text('Добавить в заявку'), findsOneWidget);

    await tester.tap(find.text('Добавить в заявку'));
    await _settle(tester);
    await tester.tap(find.text('Прибавить · будет 5 шт.'));
    await _settle(tester);
    expect(find.text('Отвод ⌀30 · теперь 5 шт.'), findsOneWidget);

    await add('Отвод ⌀30', '7');
    await tester.tap(find.text('Заменить на 7 шт.'));
    await _settle(tester);
    expect(find.text('Отвод ⌀30 · теперь 7 шт.'), findsOneWidget);

    // В заявке два новых материала, не четыре: повторы не завели позиций,
    // и второе добавление не затёрло первое. Сами строки ниже края
    // экрана, поэтому считаем по подписи.
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new).first);
    await _settle(tester);
    expect(find.text('МАТЕРИАЛЫ · 6'), findsOneWidget);
  });

  testWidgets('настройки: язык и тема выбираются в шторке', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(412, 892) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final container = await const MockRootFactory().create();
    await tester.pumpWidget(App(container: container));
    await _settle(tester);

    Future<void> pick(String row, String option) async {
      await tester.tap(find.text(row));
      await _settle(tester);
      await tester.tap(find.text(option).last);
      await _settle(tester);
    }

    await tester.tap(find.text('Настройки'));
    await _settle(tester);
    // Одна строка на настройку: значение видно, вариантов — нет.
    expect(find.text('Русский'), findsOneWidget);
    expect(find.text('English'), findsNothing);
    expect(find.text('Светлая'), findsOneWidget);

    await pick('Язык', 'English');
    expect(find.text('Requests'), findsOneWidget);

    await pick('Language', 'Қазақша');
    expect(find.text('Өтінімдер'), findsOneWidget);

    // Из кошачьего есть дорога назад: название своего языка не переводится.
    await pick('Тіл', 'Кошачий 🐱');
    expect(find.text('Кошачий 🐱'), findsOneWidget);
    await tester.tap(find.text('Кошачий 🐱'));
    await _settle(tester);
    await tester.tap(find.text('Русский'));
    await _settle(tester);
    expect(find.text('Заявки'), findsOneWidget);

    // Тема: тёмная перекрашивает и фон экрана, и текст.
    Brightness brightness() =>
        Theme.of(tester.element(find.text('Тема'))).brightness;
    expect(brightness(), Brightness.light);

    await pick('Тема', 'Тёмная');
    expect(brightness(), Brightness.dark);
    final tokens = Theme.of(
      tester.element(find.text('Тема')),
    ).extension<RequestTokens>()!;
    expect(tokens.background, isNot(RequestTokens.light().background));
    expect(tester.widget<Text>(find.text('Тема')).style?.color, tokens.ink);

    await pick('Тема', 'Светлая');
    expect(brightness(), Brightness.light);
  });

  testWidgets('requests screen on a wide window', (tester) async {
    await _render(
      tester,
      RequestsScreen(
        requests: [_request],
        totalCount: 1,
        folders: const [RequestFolder(id: 'f1', name: 'ЖК Северный', requestCount: 2)],
        folder: null,
        filter: RequestFilter.all,
        searchController: TextEditingController(),
        onSearchChanged: (_) {},
        onFilterSelected: (_) {},
        onFolderOpened: (_) {},
        onFolderCreate: () {},
        onRequestOpened: (_) {},
        onRequestCreate: () {},
      ),
      size: const Size(1280, 900),
    );
    expect(find.text('ЖК Северный, стояки Б2'), findsOneWidget);
  });
}
