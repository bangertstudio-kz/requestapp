import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Снек: тёмная плашка-подтверждение поверх контента.
///
/// Собственный виджет, а не `SnackBar`: в макете он всплывает над плавающей
/// кнопкой, не сдвигает её и не отбирает у неё нажатие. `ScaffoldMessenger`
/// делает ровно обратное.
class AppSnack extends StatelessWidget {
  const AppSnack({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Semantics(
      liveRegion: true,
      // Снек живёт в `MaterialApp.builder`, то есть выше любого `Scaffold`
      // и вне какого-либо `Material`. Без него текст получает отладочное
      // жёлтое подчёркивание «missing Material widget» прямо в релизной
      // вёрстке — Flutter так помечает текст без материаловского предка.
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space16,
            vertical: AppDimens.space14,
          ),
          decoration: BoxDecoration(
            color: tokens.snackSurface,
            borderRadius: BorderRadius.circular(AppDimens.radiusControl),
            boxShadow: tokens.snackShadow,
          ),
          child: Text(message, style: tokens.text.snack),
        ),
      ),
    );
  }
}
