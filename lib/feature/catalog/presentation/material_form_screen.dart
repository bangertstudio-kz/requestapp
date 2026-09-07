import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../core/widgets/form_action_bar.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/material_unit.dart';
import 'material_unit_label.dart';

/// Форма материала справочника: название, место в дереве и единица измерения.
///
/// Категория, подкатегория и единица выбираются чипами, а не выпадающими
/// списками: вариантов мало, а выпадающий список прячет их за нажатием
/// и не показывает, что уже выбрано, пока его не открыть.
class MaterialFormScreen extends StatelessWidget {
  const MaterialFormScreen({
    super.key,
    required this.editing,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSubcategoryId,
    required this.selectedUnit,
    required this.nameController,
    required this.formKey,
    required this.onCategorySelected,
    required this.onSubcategorySelected,
    required this.onUnitSelected,
    required this.onSave,
    required this.onCancel,
  });

  final bool editing;
  final List<CatalogCategory> categories;

  /// Выбранная категория целиком, а не её id: подкатегории берутся из неё же,
  /// и поиск по списку в каждой перестройке экрана здесь не нужен.
  final CatalogCategory selectedCategory;

  final String? selectedSubcategoryId;
  final MaterialUnit selectedUnit;

  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;

  final ValueChanged<CatalogCategory> onCategorySelected;
  final ValueChanged<String> onSubcategorySelected;
  final ValueChanged<MaterialUnit> onUnitSelected;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: FormActionBar(onCancel: onCancel, onSave: onSave),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.formTitleMaterial,
                subtitle: editing
                    ? l10n.formSubtitleEdit
                    : l10n.formSubtitleNew,
                onBack: onCancel,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.screenPadding,
                      AppDimens.space6,
                      AppDimens.screenPadding,
                      AppDimens.space26,
                    ),
                    children: [
                      AppLabeledField(
                        label: l10n.formNameLabel,
                        controller: nameController,
                        hintText: l10n.formNameHint,
                        textStyle: context.request.text.fieldMedium,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? l10n.formNameRequired
                            : null,
                      ),
                      const SizedBox(height: AppDimens.space12),
                      _ChipsCard(
                        label: l10n.formCategoryLabel,
                        children: [
                          for (final category in categories)
                            AppChip(
                              style: AppChipStyle.choice,
                              label: category.name,
                              selected: category.id == selectedCategory.id,
                              onTap: () => onCategorySelected(category),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space12),
                      _ChipsCard(
                        label: l10n.formSubcategoryLabel,
                        children: [
                          for (final subcategory
                              in selectedCategory.subcategories)
                            AppChip(
                              style: AppChipStyle.choice,
                              label: subcategory.name,
                              selected: subcategory.id == selectedSubcategoryId,
                              onTap: () =>
                                  onSubcategorySelected(subcategory.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space12),
                      _ChipsCard(
                        label: l10n.formUnitLabel,
                        // Единиц ровно три, и они делят ширину поровну:
                        // перенос по строкам здесь выглядел бы случайным.
                        stretch: true,
                        children: [
                          for (final unit in MaterialUnit.values)
                            AppChip(
                              style: AppChipStyle.unit,
                              label: materialUnitLabel(l10n, unit),
                              selected: unit == selectedUnit,
                              onTap: () => onUnitSelected(unit),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipsCard extends StatelessWidget {
  const _ChipsCard({
    required this.label,
    required this.children,
    this.stretch = false,
  });

  final String label;
  final List<Widget> children;
  final bool stretch;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(AppDimens.space14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSectionLabel(label),
        const SizedBox(height: AppDimens.space10),
        if (stretch)
          Row(
            children: [
              for (final (index, child) in children.indexed) ...[
                Expanded(child: child),
                if (index != children.length - 1)
                  const SizedBox(width: AppDimens.space8),
              ],
            ],
          )
        else
          Wrap(
            spacing: AppDimens.space8,
            runSpacing: AppDimens.space8,
            children: children,
          ),
      ],
    ),
  );
}
