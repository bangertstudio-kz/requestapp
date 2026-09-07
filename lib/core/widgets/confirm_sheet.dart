import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';

/// Шторка подтверждения необратимого действия.
///
/// Спрашивает только там, где отменить нельзя. Подтверждение на каждое
/// действие обучает нажимать «Да» не глядя — и тогда оно не защищает.
class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;

  /// Текст называет последствие, а не повторяет вопрос: «и все её 4 позиции
  /// будут удалены с устройства» — это то, чего пользователь может не знать.
  final String message;

  final String confirmLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  /// Показывает шторку и возвращает `true`, если действие подтвердили.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      // Фон прозрачный: скругление и тень рисует сама шторка, а стандартная
      // подложка добавила бы под ней второй, чуть другой угол.
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space4),
          Text(message, style: tokens.text.sheetSubtitle),
          const SizedBox(height: AppDimens.space16),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: l10n.actionCancel,
                  onPressed: onCancel,
                ),
              ),
              const SizedBox(width: AppDimens.space10),
              Expanded(
                child: AppButton.dangerFilled(
                  label: confirmLabel,
                  onPressed: onConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
