import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_add_sheet.dart';
import 'catalog_export.dart';
import 'catalog_flatten.dart';
import 'catalog_list_screen.dart';
import 'catalog_notifier.dart';
import 'catalog_row.dart';
import 'delete_category_notifier.dart';
import 'delete_item_notifier.dart';
import 'item_path_label.dart';
import 'item_unit_label.dart';
import 'reorder_items_notifier.dart';

/// Содержимое категории: вложенные категории и материалы одним списком.
///
/// Экран сам на себя и ссылается — уровней столько, сколько завели. Отдельной
/// страницы «подкатегория» больше нет: она отличалась только тем, что
/// показывала материалы вместо категорий, а теперь показывать нужно и то,
/// и другое на любом уровне.
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  /// Порядок после перетаскивания, пока справочник не перечитан.
  ///
  /// Без него строка на секунду отпрыгивает на старое место: экран рисует
  /// дерево из нотифаера, а там ещё прежний порядок.
  List<CatalogItem>? _reordered;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // go_router переиспользует State при переходе с категории на вложенную:
    // тип виджета тот же, и initState больше не вызовут.
    if (oldWidget.categoryId != widget.categoryId) {
      _reordered = null;
      _load();
    }
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<CatalogNotifier>(context).request(null);
  }

  Future<void> _open(Future<void> Function() push) async {
    await push();
    _load();
  }

  Future<void> _add(CatalogCategory category) async {
    final addition = await CatalogAddSheet.show(context);
    if (addition == null || !mounted) return;

    await _open(
      () => switch (addition) {
        CatalogAddition.category =>
          CategoryFormRoute(parentId: category.id).push<void>(context),
        CatalogAddition.item =>
          ItemFormRoute(categoryId: category.id).push<void>(context),
        CatalogAddition.import =>
          CatalogImportRoute(categoryId: category.id).push<void>(context),
      },
    );
  }

  Future<void> _deleteCategory(CatalogCategory category) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteCategoryTitle,
      message: l10n.confirmDeleteCategoryText(category.name),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteCategoryNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(CatalogEntryParams(category.id));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackCategoryRemoved);
    _load();
  }

  Future<void> _reorder(
    CatalogCategory category,
    List<CatalogItem> items,
    int oldIndex,
    int newIndex,
  ) async {
    final ordered = [...items];
    ordered.insert(newIndex, ordered.removeAt(oldIndex));
    setState(() => _reordered = ordered);

    final notifier = NotifierScope.read<ReorderItemsNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final catalog = NotifierScope.read<CatalogNotifier>(context);
    await notifier.run(
      ReorderItemsParams(
        categoryId: category.id,
        itemIds: [for (final item in ordered) item.id],
      ),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    if (failure != null) snack.show(failure);

    await catalog.request(null);
    // Перестановку, сделанную пока шло сохранение, не затираем:
    // её сохранение ещё впереди и перечитает справочник само.
    if (mounted && identical(_reordered, ordered)) {
      setState(() => _reordered = null);
    }
  }

  Future<void> _deleteItem(CatalogItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteMaterialTitle,
      message: l10n.confirmDeleteMaterialText(item.name),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteItemNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(CatalogEntryParams(item.id));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackMaterialRemovedFromCatalog);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.of<CatalogNotifier>(context);

    return RequestView<List<CatalogCategory>>(
      state: notifier.value,
      onRetry: _load,
      // Пока справочник не приехал, экран рисует шапку сам: пришедший
      // по ссылке не должен остаться на пустом листе без «назад».
      placeholderTitle: l10n.catalogTitle,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, categories) {
        final category = findCategory(categories, widget.categoryId);
        if (category == null) {
          // Категорию удалили с другого экрана: показывать её содержимое
          // нечем, и честнее закрыться, чем рисовать пустой список.
          return const SizedBox.shrink();
        }

        // Сначала вложенные категории, потом материалы: папки выше файлов —
        // тот порядок, к которому человек привык у себя на компьютере.
        final children = category.categories;
        final items = _reordered ?? category.items;

        return CatalogListScreen(
          title: category.name,
          subtitle: itemPathLabel(l10n, _pathOf(categories, category)),
          label: l10n.catalogInsideLabel(children.length + items.length),
          onBack: () => Navigator.of(context).pop(),
          actions: [
            AppIconButton(
              icon: Icons.ios_share,
              semanticLabel: l10n.catalogExportOpen,
              onPressed: () => shareCatalogExport(
                context,
                categoryId: category.id,
                subject: category.name,
              ),
            ),
          ],
          itemCount: children.length + items.length,
          emptyMessage: l10n.catalogInsideEmpty,
          reorderFrom: children.length,
          // Переставлять одну строку не с чем.
          onReorder: items.length < 2
              ? null
              : (oldIndex, newIndex) =>
                    _reorder(category, items, oldIndex, newIndex),
          itemBuilder: (context, index) {
            if (index < children.length) {
              final child = children[index];
              return CatalogRow(
                name: child.name,
                meta: l10n.catalogCategoryMeta(
                  child.categories.length + child.items.length,
                  [
                    ...child.categories.map((item) => item.name),
                    ...child.items.map((item) => item.name),
                  ].join(', '),
                ),
                onOpen: () => _open(
                  () => CategoryRoute(categoryId: child.id).push<void>(context),
                ),
                onEdit: () => _open(
                  () => CategoryFormRoute(
                    categoryId: child.id,
                  ).push<void>(context),
                ),
                onRemove: () => _deleteCategory(child),
              );
            }

            final item = items[index - children.length];
            return CatalogRow(
              key: ValueKey(item.id),
              dragIndex: items.length < 2 ? null : index - children.length,
              name: item.name,
              meta: itemUnitLabel(l10n, item.unit),
              onOpen: () =>
                  _open(() => ItemFormRoute(itemId: item.id).push<void>(context)),
              onEdit: () =>
                  _open(() => ItemFormRoute(itemId: item.id).push<void>(context)),
              onRemove: () => _deleteItem(item),
            );
          },
          fabLabel: l10n.catalogAdd,
          onFabPressed: () => _add(category),
        );
      },
    );
  }

  /// Путь до самой категории — для подзаголовка. На третьем уровне одного
  /// названия в шапке мало: «Труба» есть и в канализации, и в ППР.
  static List<String> _pathOf(
    List<CatalogCategory> categories,
    CatalogCategory category,
  ) {
    final byId = {
      for (final item in flattenCategories(categories)) item.id: item,
    };
    final names = <String>[];
    final seen = <String>{};
    CatalogCategory? cursor = category;
    while (cursor != null && seen.add(cursor.id)) {
      names.insert(0, cursor.name);
      final parentId = cursor.parentId;
      cursor = parentId == null ? null : byId[parentId];
    }
    return names;
  }
}
