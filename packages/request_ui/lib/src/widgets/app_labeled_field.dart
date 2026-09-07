import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'app_card.dart';
import 'app_section_label.dart';

/// Поле ввода в карточке: подпись сверху, текст без рамки снизу.
///
/// Рамку несёт карточка, а не `InputDecoration`: две рамки на одном поле —
/// это то, из-за чего форма выглядит собранной из чужих деталей.
class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.textStyle,
    this.validator,
    this.onChanged,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;

  /// Название заявки набрано крупнее названия справочной записи —
  /// стиль задаёт вызывающий экран.
  final TextStyle? textStyle;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space14,
        vertical: AppDimens.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSectionLabel(label),
          const SizedBox(height: AppDimens.space4),
          TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            textInputAction: textInputAction,
            style: textStyle ?? tokens.text.fieldStrong,
            cursorColor: tokens.primary,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: tokens.text.fieldHint,
              errorStyle: tokens.text.bodySmall.copyWith(color: tokens.danger),
            ),
          ),
        ],
      ),
    );
  }
}
