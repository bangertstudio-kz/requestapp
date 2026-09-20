import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../core/widgets/form_action_bar.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/item_unit.dart';
import 'item_unit_label.dart';

/// Форма материала справочника: название, место в дереве и единица измерения.
///
/// Категория, подкатегория и единица выбираются чипами, а не выпадающими
/// списками: вариантов мало, а выпадающий список прячет их за нажатием
/// и не показывает, что уже выбрано, пока его не открыть.
class ItemFormScreen extends StatelessWidget {
  const ItemFormScreen({
    super.key,
    required this.editing,
    required this.categoryLabel,
    required this.selectedUnit,
    required this.nameController,
    required this.formKey,
    required this.onCategoryTap,
    required this.onUnitSelected,
    required this.onSave,
    required this.onCancel,
  });

  final bool editing;

  /// Путь выбранной категории строкой или подсказка «выберите» — экран
  /// показывает готовую фразу, а не собирает её из дерева.
  final String categoryLabel;

  final ItemUnit selectedUnit;

  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;

  final VoidCallback onCategoryTap;
  final ValueChanged<ItemUnit> onUnitSelected;
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
                      // Одна строка вместо двух рядов чипов: категорий
                      // с произвольной вложенностью может быть полсотни,
                      // и чипами они превращаются в стену.
                      _CategoryField(
                        label: categoryLabel,
                        onTap: onCategoryTap,
                      ),
                      const SizedBox(height: AppDimens.space12),
                      _ChipsCard(
                        label: l10n.formUnitLabel,
                        // Единиц ровно три, и они делят ширину поровну:
                        // перенос по строкам здесь выглядел бы случайным.
                        stretch: true,
                        children: [
                          for (final unit in ItemUnit.values)
                            AppChip(
                              style: AppChipStyle.unit,
                              label: itemUnitLabel(l10n, unit),
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


/// Выбранная категория одной строкой: путь и стрелка вправо.
class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Material(
      color: tokens.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.space12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.formCategoryLabel,
                style: tokens.text.meta.copyWith(color: tokens.inkTertiary),
              ),
              const SizedBox(height: AppDimens.space6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: tokens.text.rowTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: tokens.inkTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
