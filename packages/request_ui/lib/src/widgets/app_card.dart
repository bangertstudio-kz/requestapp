import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'hover_builder.dart';

/// Белая карточка на сером фоне: базовая поверхность всего приложения.
///
/// Границу рисует рамка, а не тень. Тень на списке из двадцати карточек
/// превращается в грязь между ними, рамка — нет.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1,
    this.color,
    this.minHeight,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? color;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(borderRadius ?? AppDimens.radiusCard);

    return HoverBuilder(
      enabled: onTap != null,
      builder: (context, hovered, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? tokens.surface,
          borderRadius: radius,
          border: Border.all(
            // Наведение подсвечивает только то, что нажимается: карточка без
            // onTap не должна обещать реакцию, которой не будет.
            color: hovered
                ? tokens.borderHover
                : (borderColor ?? tokens.border),
            width: borderWidth,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: minHeight == null
                  ? child
                  : ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minHeight!),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
