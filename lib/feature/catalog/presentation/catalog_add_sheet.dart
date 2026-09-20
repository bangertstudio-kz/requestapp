import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';

/// Что добавляют внутрь категории.
enum CatalogAddition { category, item, import }

/// Шторка выбора: категорию или материал.
///
/// Появилась вместе с тем, что категория хранит и то, и другое. Две кнопки
/// в шапке вместо одной занимали бы место на каждом экране ради выбора,
/// который делают раз в сессию.
class CatalogAddSheet extends StatelessWidget {
  const CatalogAddSheet({
    super.key,
    required this.onSelected,
    required this.onCancel,
  });

  final ValueChanged<CatalogAddition> onSelected;
  final VoidCallback onCancel;

  static Future<CatalogAddition?> show(BuildContext context) =>
      showModalBottomSheet<CatalogAddition>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => CatalogAddSheet(
          onSelected: (value) => Navigator.of(context).pop(value),
          onCancel: () => Navigator.of(context).pop(),
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
          Text(l10n.catalogAddTitle, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space14),
          AppButton.outlined(
            label: l10n.catalogAddCategory,
            size: AppButtonSize.medium,
            onPressed: () => onSelected(CatalogAddition.category),
          ),
          const SizedBox(height: AppDimens.space10),
          // Импорт здесь, а не только в шапке справочника: загружают
          // обычно раздел целиком, и приёмник уже выбран — тот, откуда
          // открыли шторку.
          AppButton.outlined(
            label: l10n.catalogImportOpen,
            size: AppButtonSize.medium,
            onPressed: () => onSelected(CatalogAddition.import),
          ),
          const SizedBox(height: AppDimens.space10),
          // Материал — предполагаемый выбор: категорий заводят единицы,
          // материалов — сотни.
          AppButton.filled(
            label: l10n.catalogAddItem,
            onPressed: () => onSelected(CatalogAddition.item),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.neutralText(label: l10n.actionCancel, onPressed: onCancel),
        ],
      ),
    );
  }
}
