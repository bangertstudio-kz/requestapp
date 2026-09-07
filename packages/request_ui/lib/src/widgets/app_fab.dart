import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Расширенная плавающая кнопка: единственный элемент макета с тенью.
///
/// Тень синяя, а не серая: серая под синей кнопкой читается как грязь.
class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(AppDimens.radiusFab);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.primary,
        borderRadius: radius,
        boxShadow: tokens.fabShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: SizedBox(
            height: AppDimens.fabHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.space18,
                right: AppDimens.space22,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20, color: tokens.surface),
                  const SizedBox(width: AppDimens.space10),
                  Text(
                    label,
                    style: tokens.text.fab.copyWith(color: tokens.surface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
