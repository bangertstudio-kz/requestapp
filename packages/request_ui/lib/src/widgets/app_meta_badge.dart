import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Моноширинная плашка справа в строке дерева: единица измерения материала.
///
/// На выбранной строке инвертируется — белая на голубом фоне строки, — иначе
/// растворяется в подсветке выбора.
class AppMetaBadge extends StatelessWidget {
  const AppMetaBadge({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space8,
        vertical: AppDimens.space4,
      ),
      decoration: BoxDecoration(
        color: selected ? tokens.surface : tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(AppDimens.radiusBadge),
      ),
      child: Text(
        label,
        style: tokens.text.meta.copyWith(
          color: selected ? tokens.primary : tokens.inkTertiary,
        ),
      ),
    );
  }
}
