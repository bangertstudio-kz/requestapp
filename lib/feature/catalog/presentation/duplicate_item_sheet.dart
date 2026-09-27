import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';

/// Что сделать с материалом, который уже есть в заявке.
enum DuplicateChoice { add, replace }

/// Шторка выбора, когда добавляемый материал уже лежит в заявке.
///
/// Вторая позиция того же материала не заводится: у кладовщика две строки
/// «Отвод ⌀50» читаются как ошибка, и складывать их приходится ему.
/// Отмена возвращает к количеству — его можно поправить и добавить снова.
class DuplicateItemSheet extends StatelessWidget {
  const DuplicateItemSheet({
    super.key,
    required this.name,
    required this.unit,
    required this.current,
    required this.quantity,
    required this.onSelected,
    required this.onCancel,
  });

  final String name;

  /// Подпись единицы, уже готовая к показу.
  final String unit;

  /// Количество в заявке сейчас.
  final int current;

  /// Только что введённое количество.
  final int quantity;

  final ValueChanged<DuplicateChoice> onSelected;
  final VoidCallback onCancel;

  /// Показывает шторку и возвращает выбор или `null`, если отменили.
  static Future<DuplicateChoice?> show(
    BuildContext context, {
    required String name,
    required String unit,
    required int current,
    required int quantity,
  }) => showModalBottomSheet<DuplicateChoice>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => DuplicateItemSheet(
      name: name,
      unit: unit,
      current: current,
      quantity: quantity,
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
          Text(l10n.duplicateTitle, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space4),
          Text(
            l10n.duplicateText(name, current, unit),
            style: tokens.text.sheetSubtitle,
          ),
          const SizedBox(height: AppDimens.space14),
          // Прибавить — предполагаемый выбор: второй раз материал
          // добавляют обычно для следующего стояка, а не взамен первого.
          AppButton.filled(
            label: l10n.duplicateAdd(current + quantity, unit),
            onPressed: () => onSelected(DuplicateChoice.add),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.outlined(
            label: l10n.duplicateReplace(quantity, unit),
            size: AppButtonSize.medium,
            onPressed: () => onSelected(DuplicateChoice.replace),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.neutralText(label: l10n.actionCancel, onPressed: onCancel),
        ],
      ),
    );
  }
}
