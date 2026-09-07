import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'app_icon_button.dart';

/// Шапка экрана: кнопка «назад», заголовок и подзаголовок.
///
/// Не `AppBar`: в макете шапка стоит на том же фоне, что и контент, без
/// линии, тени и центрирования, а подзаголовок — часть шапки, а не отдельный
/// `bottom`. Воспроизводить это через `AppBar` дороже, чем нарисовать.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.backSemanticLabel,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;

  /// `null` — экран корневой, стрелки нет. Место под неё не резервируется:
  /// заголовок корневого экрана начинается от края, как в макете.
  final VoidCallback? onBack;
  final String? backSemanticLabel;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    assert(
      onBack == null || backSemanticLabel != null,
      'Кнопке «назад» нужна подпись из ARB.',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space8,
        AppDimens.space4,
        AppDimens.space8,
        AppDimens.space8,
      ),
      child: Row(
        children: [
          if (onBack != null)
            AppIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: onBack,
              semanticLabel: backSemanticLabel!,
              iconSize: 18,
            ),
          const SizedBox(width: AppDimens.space4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text.appBarTitle,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.appBarSubtitle,
                    ),
                ],
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
