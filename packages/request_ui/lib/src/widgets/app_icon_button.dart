import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Круглая кнопка с одной иконкой: «назад», «очистить», «закрыть».
///
/// [semanticLabel] обязателен: кнопка без текста для скринридера — пустая
/// кнопка, и подпись к ней приходит из ARB так же, как любая другая строка.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = AppDimens.touchTarget,
    this.iconSize = 20,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    // Кнопка прозрачная: увеличение до минимальной зоны нажатия меняет
    // только радиус отклика, а не то, что видно на экране.
    return SizedBox.square(
      dimension: math.max(size, AppDimens.touchTargetMin),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: color ?? tokens.ink,
              semanticLabel: semanticLabel,
            ),
          ),
        ),
      ),
    );
  }
}
