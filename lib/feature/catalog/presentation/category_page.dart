import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_params.dart';
import '../domain/entities/catalog_subcategory.dart';
import 'catalog_list_screen.dart';
import 'catalog_notifier.dart';
import 'catalog_row.dart';
import 'delete_subcategory_notifier.dart';

/// Подкатегории внутри категории.
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<CatalogNotifier>(context).request(null);
  }

  Future<void> _open(Future<void> Function() push) async {
    await push();
    _load();
  }

  Future<void> _delete(CatalogSubcategory subcategory) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteSubcategoryTitle,
      message: l10n.confirmDeleteSubcategoryText(subcategory.name),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteSubcategoryNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(CatalogEntryParams(subcategory.id));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackSubcategoryRemoved);
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
        final category = categories
            .where((item) => item.id == widget.categoryId)
            .firstOrNull;
        if (category == null) {
          // Категорию удалили с другого экрана: показывать её содержимое
          // нечем, и честнее закрыться, чем рисовать пустой список.
          return const SizedBox.shrink();
        }

        final materialCount = category.subcategories.fold<int>(
          0,
          (sum, item) => sum + item.materials.length,
        );

        return CatalogListScreen(
          title: category.name,
          subtitle: l10n.catalogMaterialsInCategory(materialCount),
          label: l10n.catalogSubcategoriesLabel(category.subcategories.length),
          onBack: () => Navigator.of(context).pop(),
          itemCount: category.subcategories.length,
          emptyMessage: l10n.catalogSubcategoriesEmpty,
          itemBuilder: (context, index) {
            final subcategory = category.subcategories[index];
            return CatalogRow(
              name: subcategory.name,
              meta: l10n.catalogMaterialsCount(subcategory.materials.length),
              onOpen: () => _open(
                () => SubcategoryRoute(
                  categoryId: category.id,
                  subcategoryId: subcategory.id,
                ).push<void>(context),
              ),
              onEdit: () => _open(
                () => SubcategoryFormRoute(
                  categoryId: category.id,
                  subcategoryId: subcategory.id,
                ).push<void>(context),
              ),
              onRemove: () => _delete(subcategory),
            );
          },
          fabLabel: l10n.catalogNewSubcategory,
          onFabPressed: () => _open(
            () => SubcategoryFormRoute(
              categoryId: category.id,
            ).push<void>(context),
          ),
        );
      },
    );
  }
}
