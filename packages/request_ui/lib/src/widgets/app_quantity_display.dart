import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'app_section_label.dart';

/// Табло количества: подпись слева, крупное число и единица справа.
///
/// Рамка акцентная и полуторная — это единственное поле на экране, ради
/// которого экран открыли, и оно обязано быть видно, не будучи кнопкой.
class AppQuantityDisplay extends StatelessWidget {
  const AppQuantityDisplay({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.unit,
    this.empty = false,
    this.onSurface = true,
  });

  final String label;
  final String hint;

  /// Уже отформатированное значение. Форматирование числа — работа экрана:
  /// оно зависит от локали, а дизайн-система локали не знает.
  final String value;
  final String unit;

  /// Ноль-заглушка вместо введённого значения — блёклый, чтобы не выглядеть
  /// как выбранное пользователем количество.
  final bool empty;

  /// В шторке табло стоит на белом фоне и само окрашивается в серый,
  /// на экране позиции — наоборот.
  final bool onSurface;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space18,
        vertical: AppDimens.space14,
      ),
      decoration: BoxDecoration(
        color: onSurface ? tokens.surface : tokens.background,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: tokens.primary, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSectionLabel(label),
                const SizedBox(height: AppDimens.space4),
                Text(hint, style: tokens.text.caption),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.space10),
          Text(
            value,
            style: tokens.text.quantityDisplay.copyWith(
              color: empty ? tokens.inkDisabled : tokens.ink,
            ),
          ),
          const SizedBox(width: AppDimens.space10),
          Text(unit, style: tokens.text.quantityUnit),
        ],
      ),
    );
  }
}
