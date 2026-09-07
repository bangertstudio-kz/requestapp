import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_material.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_list_screen.dart';
import 'catalog_notifier.dart';
import 'catalog_row.dart';
import 'delete_material_notifier.dart';
import 'material_unit_label.dart';

/// Материалы внутри подкатегории.
class SubcategoryPage extends StatefulWidget {
  const SubcategoryPage({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
  });

  final String categoryId;
  final String subcategoryId;

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
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

  Future<void> _delete(CatalogMaterial material) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteMaterialTitle,
      message: l10n.confirmDeleteMaterialText(material.name),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteMaterialNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(CatalogEntryParams(material.id));
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
      placeholderTitle: l10n.catalogTitle,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, categories) {
        final category = categories
            .where((item) => item.id == widget.categoryId)
            .firstOrNull;
        final subcategory = category?.subcategories
            .where((item) => item.id == widget.subcategoryId)
            .firstOrNull;
        if (category == null || subcategory == null) {
          return const SizedBox.shrink();
        }

        return CatalogListScreen(
          title: subcategory.name,
          subtitle: l10n.materialPath(category.name, subcategory.name),
          label: l10n.catalogMaterialsLabel(subcategory.materials.length),
          onBack: () => Navigator.of(context).pop(),
          itemCount: subcategory.materials.length,
          emptyMessage: l10n.catalogMaterialsEmpty,
          itemBuilder: (context, index) {
            final material = subcategory.materials[index];
            return CatalogRow(
              name: material.name,
              meta: materialUnitLabel(l10n, material.unit),
              onOpen: () => _open(
                () => MaterialFormRoute(
                  materialId: material.id,
                ).push<void>(context),
              ),
              onEdit: () => _open(
                () => MaterialFormRoute(
                  materialId: material.id,
                ).push<void>(context),
              ),
              onRemove: () => _delete(material),
            );
          },
          fabLabel: l10n.catalogNewMaterial,
          onFabPressed: () => _open(
            () => MaterialFormRoute(
              categoryId: category.id,
              subcategoryId: subcategory.id,
            ).push<void>(context),
          ),
        );
      },
    );
  }
}
