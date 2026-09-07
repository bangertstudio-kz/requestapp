import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';
import '../presentation/content_column.dart';

/// Нижняя панель формы: отмена слева, сохранение справа.
///
/// Общая для всех форм приложения, потому что расположение кнопок «отмена /
/// сохранить» — это то, что пользователь запоминает один раз. Форма, где они
/// поменялись местами, стирает эту память.
class FormActionBar extends StatelessWidget {
  const FormActionBar({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: ContentColumn(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.screenPadding,
              AppDimens.space12,
              AppDimens.screenPadding,
              AppDimens.space16,
            ),
            child: Row(
              children: [
                AppButton.outlined(
                  label: l10n.actionCancel,
                  expanded: false,
                  width: 110,
                  onPressed: onCancel,
                ),
                const SizedBox(width: AppDimens.space10),
                Expanded(
                  child: AppButton.filled(
                    label: l10n.actionSave,
                    onPressed: onSave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
