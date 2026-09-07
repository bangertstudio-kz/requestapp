import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/send_format.dart';

/// Шторка выбора формата отправки.
///
/// Выбор форматом, а не галочками: два флажка и кнопка «Отправить» — три
/// нажатия там, где хватает одного, и состояние «ни одного формата», которое
/// нечем осмысленно обработать.
class SendRequestSheet extends StatelessWidget {
  const SendRequestSheet({
    super.key,
    required this.onSelected,
    required this.onCancel,
  });

  final ValueChanged<SendFormat> onSelected;
  final VoidCallback onCancel;

  /// Показывает шторку и возвращает выбранный формат или `null` при отмене.
  static Future<SendFormat?> show(BuildContext context) =>
      showModalBottomSheet<SendFormat>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => SendRequestSheet(
          onSelected: (format) => Navigator.of(context).pop(format),
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
          Text(l10n.sendSheetTitle, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space4),
          Text(l10n.sendSheetSubtitle, style: tokens.text.sheetSubtitle),
          const SizedBox(height: AppDimens.space14),
          AppButton.outlined(
            label: l10n.sendFormatXml,
            size: AppButtonSize.medium,
            onPressed: () => onSelected(SendFormat.xml),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.outlined(
            label: l10n.sendFormatPdf,
            size: AppButtonSize.medium,
            onPressed: () => onSelected(SendFormat.pdf),
          ),
          const SizedBox(height: AppDimens.space10),
          // Оба формата — предполагаемый выбор, поэтому единственная
          // залитая кнопка в шторке.
          AppButton.filled(
            label: l10n.sendFormatBoth,
            onPressed: () => onSelected(SendFormat.both),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.neutralText(label: l10n.actionCancel, onPressed: onCancel),
        ],
      ),
    );
  }
}
