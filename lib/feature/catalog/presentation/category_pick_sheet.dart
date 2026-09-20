import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import 'item_path_label.dart';

/// Выбор категории — родителя для другой категории или места для материала.
///
/// Плоский список с полным путём, а не разворачиваемое дерево: выбирают
/// один раз, а дерево на четырёх уровнях внутри шторки листается дольше,
/// чем читается список путей.
///
/// Кнопки отмены нет: шторка закрывается смахиванием и нажатием вне её —
/// тем же жестом, что и любая другая. Кнопка повторяла бы его и занимала
/// строку, которой не хватает списку.
class CategoryPickSheet extends StatelessWidget {
  const CategoryPickSheet({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  /// Уже отфильтрованный список: вызывающий убирает то, что выбрать нельзя.
  final List<({CatalogCategory category, List<String> path})> options;

  final String? selectedId;
  final ValueChanged<String> onSelected;

  static Future<String?> show(
    BuildContext context, {
    required List<({CatalogCategory category, List<String> path})> options,
    required String? selectedId,
  }) => showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => CategoryPickSheet(
      options: options,
      selectedId: selectedId,
      onSelected: (id) => Navigator.of(context).pop(id),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.formParentLabel, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space14),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in options)
                    _Row(
                      label: itemPathLabel(l10n, option.path),
                      selected: option.category.id == selectedId,
                      onTap: () => onSelected(option.category.id),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Material(
        color: selected ? tokens.primarySelected : tokens.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: selected ? tokens.borderSelectedSoft : tokens.border,
              ),
            ),
            child: Text(
              label,
              style: tokens.text.rowTitle.copyWith(
                color: selected ? tokens.primary : tokens.ink,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
