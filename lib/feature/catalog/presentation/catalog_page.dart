import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../core/widgets/tab_shell.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_flatten.dart';
import 'catalog_list_screen.dart';
import 'catalog_notifier.dart';
import 'catalog_row.dart';
import 'delete_category_notifier.dart';
import 'delete_item_notifier.dart';
import 'item_path_label.dart';
import 'item_unit_label.dart';

/// Корневой экран справочника: категории или все материалы.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  CatalogTab _tab = CatalogTab.categories;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<CatalogNotifier>(context).request(null);
  }

  Future<void> _openRoute(GoRouteDataPush push) async {
    await push();
    _load();
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

  Future<void> _deleteItem(String id, String name) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteMaterialTitle,
      message: l10n.confirmDeleteMaterialText(name),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteItemNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(CatalogEntryParams(id));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackMaterialRemovedFromCatalog);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.of<CatalogNotifier>(context);

    return TabShell(
      index: 1,
      child: RequestView<List<CatalogCategory>>(
        state: notifier.value,
        onRetry: _load,
        builder: (context, categories) {
          final items = _tab == CatalogTab.items
              ? flattenItems(categories)
              : const <CatalogItem>[];

          return CatalogListScreen(
            title: l10n.catalogTitle,
            subtitle: l10n.catalogSubtitle,
            label: _tab == CatalogTab.categories
                ? l10n.catalogCategoriesLabel(categories.length)
                : l10n.catalogMaterialsLabel(items.length),
            tab: _tab,
            onTabSelected: (value) => setState(() => _tab = value),
            actions: [
              AppIconButton(
                icon: Icons.upload_file_outlined,
                semanticLabel: l10n.catalogImportOpen,
                onPressed: () => _openRoute(
                  () => const CatalogImportRoute().push<void>(context),
                ),
              ),
            ],
            itemCount: _tab == CatalogTab.categories
                ? categories.length
                : items.length,
            emptyMessage: _tab == CatalogTab.categories
                ? l10n.catalogCategoriesEmpty
                : l10n.catalogMaterialsEmptyAll,
            itemBuilder: (context, index) {
              if (_tab == CatalogTab.categories) {
                final category = categories[index];
                return CatalogRow(
                  name: category.name,
                  meta: l10n.catalogCategoryMeta(
                    category.categories.length + category.items.length,
                    [
                      ...category.categories.map((item) => item.name),
                      ...category.items.map((item) => item.name),
                    ].join(', '),
                  ),
                  onOpen: () => _openRoute(
                    () => CategoryRoute(
                      categoryId: category.id,
                    ).push<void>(context),
                  ),
                  onEdit: () => _openRoute(
                    () => CategoryFormRoute(
                      categoryId: category.id,
                    ).push<void>(context),
                  ),
                  onRemove: () => _deleteCategory(category),
                );
              }

              final item = items[index];
              return CatalogRow(
                name: item.name,
                meta: l10n.catalogMaterialMeta(
                  itemPathLabel(l10n, item.path),
                  itemUnitLabel(l10n, item.unit),
                ),
                onOpen: () => _openRoute(
                  () => ItemFormRoute(
                    itemId: item.id,
                  ).push<void>(context),
                ),
                onEdit: () => _openRoute(
                  () => ItemFormRoute(
                    itemId: item.id,
                  ).push<void>(context),
                ),
                onRemove: () => _deleteItem(item.id, item.name),
              );
            },
            fabLabel: _tab == CatalogTab.categories
                ? l10n.catalogNewCategory
                : l10n.catalogNewMaterial,
            onFabPressed: () => _openRoute(
              () => _tab == CatalogTab.categories
                  ? const CategoryFormRoute().push<void>(context)
                  : const ItemFormRoute().push<void>(context),
            ),
          );
        },
      ),
    );
  }
}

/// Открыть маршрут и дождаться возврата.
typedef GoRouteDataPush = Future<void> Function();
