import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Нижняя шторка: белая панель со скруглённым верхом, ручкой и тенью вверх.
///
/// Кладётся в `showModalBottomSheet` или прямо в `Stack` экрана. Внутренний
/// отступ снизу учитывает системную зону жестов — шторка обязана касаться
/// края экрана, но её кнопки — нет.
class AppSheet extends StatelessWidget {
  const AppSheet({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusSheet),
        ),
        border: Border(top: BorderSide(color: tokens.borderStrong)),
        boxShadow: tokens.sheetShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding ??
              const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                AppDimens.space10,
                AppDimens.screenPadding,
                AppDimens.space16,
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppDimens.sheetHandleWidth,
                  height: AppDimens.sheetHandleHeight,
                  margin: const EdgeInsets.only(bottom: AppDimens.space12),
                  decoration: BoxDecoration(
                    color: tokens.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
