import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Квадратная кнопка «плюс»/«минус» в карточке позиции заявки.
///
/// Шире, чем выше (48×44): палец промахивается по горизонтали чаще.
/// В макете 44×40 — здесь на четыре точки больше, потому что правило
/// «зона нажатия ≥ 44» важнее совпадения до пикселя: этими двумя кнопками
/// правят количество прямо на объекте, и промах меняет цифру в заявке.
class AppStepperButton extends StatelessWidget {
  const AppStepperButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(AppDimens.radiusButtonSmall);
    return SizedBox(
      width: AppDimens.touchTarget,
      height: AppDimens.touchTargetMin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: radius,
          border: Border.all(color: tokens.borderStrong),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: onPressed == null ? tokens.inkDisabled : tokens.primary,
                semanticLabel: semanticLabel,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
