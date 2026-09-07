import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'app_icon_button.dart';

/// Строка поиска: карточка с лупой, полем и крестиком очистки.
///
/// Крестик появляется только когда есть что стирать — постоянная кнопка
/// «очистить» на пустом поле обещает действие, которого нет.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.clearSemanticLabel,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final String clearSemanticLabel;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Container(
      height: AppDimens.fieldHeight,
      padding: const EdgeInsets.only(left: AppDimens.space14, right: 6),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusControl),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: tokens.inkMuted),
          const SizedBox(width: AppDimens.space10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: tokens.text.field,
              cursorColor: tokens.primary,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: tokens.text.fieldHint,
              ),
            ),
          ),
          // Подписка на сам контроллер, а не на состояние экрана: крестик
          // обязан появиться и когда текст поставили программно.
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox(width: AppDimens.space8)
                : AppIconButton(
                    icon: Icons.close,
                    size: 32,
                    iconSize: 17,
                    color: tokens.inkTertiary,
                    semanticLabel: clearSemanticLabel,
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
