import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

/// Показывает снек поверх содержимого, не сдвигая его.
///
/// Оборачивает всё приложение, а не отдельный экран: сообщение «Материал
/// добавлен» переживает переход на экран заявки, а `ScaffoldMessenger`
/// на переходе снек уронил бы вместе со старым `Scaffold`.
class SnackOverlay extends StatelessWidget {
  const SnackOverlay({super.key, required this.child, required this.message});

  final Widget child;

  /// `null` — показывать нечего. Готовая фраза: превращать ошибку в текст —
  /// работа нотифаера, а не этого виджета.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;

    return Stack(
      children: [
        child,
        if (text != null)
          Positioned(
            left: AppDimens.screenPadding,
            right: AppDimens.screenPadding,
            // Над плавающей кнопкой, как в макете.
            bottom: 98,
            // Снек не перехватывает нажатия: на экране заявки он на две
            // секунды накрывает «Добавить материал», и отбирать у кнопки
            // касание ровно тогда, когда её жмут повторно, — худшее, что
            // может сделать сообщение об успехе.
            child: IgnorePointer(child: AppSnack(message: text)),
          ),
      ],
    );
  }
}
