import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Кнопка «наверх» для длинных списков.
///
/// В справочнике 326 материалов, и в раскрытой категории ППР их 154: пролистать
/// обратно к строке поиска — это десяток махов пальцем. Кнопка появляется
/// только когда список действительно уехал, иначе она заслоняет содержимое
/// ради действия, которое пока ничего не делает.
class AppScrollTopButton extends StatelessWidget {
  const AppScrollTopButton({
    super.key,
    required this.label,
    required this.visible,
    required this.onPressed,
  });

  final String label;
  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(AppDimens.touchTargetMin / 2);

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 140),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: radius,
            border: Border.all(color: tokens.borderStrong),
            boxShadow: tokens.snackShadow,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: SizedBox(
                height: AppDimens.touchTargetMin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 17,
                        color: tokens.primary,
                      ),
                      const SizedBox(width: AppDimens.space6),
                      Text(
                        label,
                        style: tokens.text.buttonText.copyWith(
                          color: tokens.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
