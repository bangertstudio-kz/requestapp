// Временная проверка вёрстки: рендерим каждый экран и ловим overflow.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/widgets/confirm_sheet.dart';
import 'package:request/core/widgets/name_form_screen.dart';
import 'package:request/feature/catalog/domain/entities/catalog_category.dart';
import 'package:request/feature/catalog/domain/entities/catalog_import_summary.dart';
import 'package:request/feature/catalog/domain/entities/catalog_material.dart';
import 'package:request/feature/catalog/domain/entities/catalog_subcategory.dart';
import 'package:request/feature/catalog/domain/entities/material_unit.dart';
import 'package:request/feature/catalog/presentation/catalog_import_screen.dart';
import 'package:request/feature/catalog/presentation/catalog_list_screen.dart';
import 'package:request/feature/catalog/presentation/catalog_row.dart';
import 'package:request/feature/catalog/presentation/material_form_screen.dart';
import 'package:request/feature/catalog/presentation/material_pick_screen.dart';
import 'package:request/feature/catalog/presentation/quantity_controller.dart';
import 'package:request/feature/requests/domain/entities/material_request.dart';
import 'package:request/feature/requests/domain/entities/request_filter.dart';
import 'package:request/feature/requests/domain/entities/request_folder.dart';
import 'package:request/feature/requests/domain/entities/request_item.dart';
import 'package:request/feature/requests/domain/entities/request_status.dart';
import 'package:request/feature/requests/presentation/request_detail_screen.dart';
import 'package:request/feature/requests/presentation/request_item_screen.dart';
import 'package:request/feature/requests/presentation/requests_screen.dart';
import 'package:request/feature/requests/presentation/send_request_sheet.dart';
import 'package:request/generated/app_localizations.dart';
import 'package:request/core/dependencies/container/mock_dependency_factory.dart';
import 'package:request/main.dart';
import 'package:request_ui/request_ui.dart';

final _material = CatalogMaterial(
  id: 'm1',
  name: 'Труба ⌀100/2000',
  unit: MaterialUnit.piece,
  categoryName: 'Канализация',
  subcategoryName: 'Труба',
);

final _categories = [
  CatalogCategory(
    id: 'c1',
    name: 'Канализация',
    subcategories: [
      CatalogSubcategory(id: 's1', name: 'Труба', materials: [_material]),
      const CatalogSubcategory(id: 's2', name: 'Отвод', materials: []),
    ],
  ),
  const CatalogCategory(id: 'c2', name: 'ППР', subcategories: []),
];

final _item = RequestItem(
  id: 'i1',
  name: 'Труба ⌀100/2000',
  categoryName: 'Канализация',
  subcategoryName: 'Труба',
  quantity: 24,
  unit: MaterialUnit.piece,
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
const _materialName = 'Труба ⌀100/2000';
const _confirmTitle = 'Удалить заявку?';
const _confirmMessage = 'Заявка «ЖК Северный» и все её 4 позиций будут удалены.';
const _confirmAction = 'Удалить';
const _subcategoryId = 's1';
const _importFile = 'Прайс сантехника-SergeyM 2.xlsx';
const _importError = 'Не удалось прочитать файл.';

Widget _host(Widget child) => MaterialApp(
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
        request: _request,
        nameController: TextEditingController(text: _request.name),
        onNameChanged: (_) {},
        onAddMaterial: () {},
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

  testWidgets('request item', (tester) async {
    await _render(
      tester,
      RequestItemScreen(
        item: _item,
        requestName: _request.name,
        quantityController: QuantityController.fromQuantity(24),
        onReplaceMaterial: () {},
        onSave: () {},
        onDelete: () {},
        onBack: () {},
      ),
    );
    expect(find.text('Заменить материал'), findsOneWidget);
  });

  testWidgets('material pick: tree', (tester) async {
    await _render(
      tester,
      MaterialPickScreen(
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
    expect(find.text('Канализация'), findsOneWidget);
    expect(find.text('Труба'), findsOneWidget);
  });

  testWidgets('material pick: selected shows sheet', (tester) async {
    await _render(
      tester,
      MaterialPickScreen(
        categories: _categories,
        searchResults: [_material],
        searchLoading: false,
        searchController: TextEditingController(text: 'труба'),
        onSearchChanged: (_) {},
        selected: _material,
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

  testWidgets('material form', (tester) async {
    await _render(
      tester,
      MaterialFormScreen(
        editing: true,
        categories: _categories,
        selectedCategory: _categories.first,
        selectedSubcategoryId: _subcategoryId,
        selectedUnit: MaterialUnit.meter,
        nameController: TextEditingController(text: _materialName),
        formKey: GlobalKey<FormState>(),
        onCategorySelected: (_) {},
        onSubcategorySelected: (_) {},
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
    expect(find.text('XML и PDF'), findsOneWidget);
  });

  testWidgets('catalog import: all states', (tester) async {
    await _render(
      tester,
      CatalogImportScreen(
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
        summary: const CatalogImportSummary(
          fileName: _importFile,
          categories: 6,
          subcategories: 51,
          materials: 326,
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
    expect(find.text('Заменить справочник'), findsOneWidget);
  });

  testWidgets('material pick: nothing found', (tester) async {
    await _render(
      tester,
      MaterialPickScreen(
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
    // Первая категория раскрыта сразу — видно и её, и подкатегории.
    expect(find.text('Канализация'), findsOneWidget);
    expect(find.text('Труба'), findsOneWidget);

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
