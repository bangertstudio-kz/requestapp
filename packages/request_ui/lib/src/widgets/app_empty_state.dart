import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Пустое состояние: пунктирная рамка с объяснением, что делать дальше.
///
/// Пунктир, а не сплошная рамка: сплошная выглядит как карточка, в которой
/// что-то есть, — а здесь как раз нет ничего.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, required this.message});

  /// Текст с переносом строки внутри: в макете вторая строка — подсказка
  /// действия, и она обязана стоять отдельной строкой, а не переноситься
  /// как придётся.
  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: tokens.borderDashed,
        radius: AppDimens.radiusCard,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space18,
          vertical: AppDimens.space26,
        ),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: tokens.text.emptyState,
          ),
        ),
      ),
    );
  }
}

/// Пунктирная скруглённая рамка: во Flutter нет `BorderStyle.dashed`.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  /// Штрих и просвет подобраны так, чтобы на радиусе 14 не съедало угол.
  static const double dash = 5;
  static const double gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
