import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Тон чипа статуса. Именно тон, а не статус: дизайн-система не обязана знать,
/// что заявка бывает черновиком — она знает, что бывает нейтральное,
/// подтверждённое и отправленное.
enum AppStatusTone { neutral, positive, info }

/// Небольшой чип статуса в углу карточки.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.tone,
    this.dense = false,
  });

  final String label;
  final AppStatusTone tone;

  /// В шапке заявки чип стоит в одной строке с датой и жмётся по вертикали.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final (background, foreground) = switch (tone) {
      AppStatusTone.neutral => (tokens.surfaceNeutral, tokens.inkSecondary),
      AppStatusTone.positive => (tokens.successTint, tokens.success),
      AppStatusTone.info => (tokens.primarySelected, tokens.primary),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: dense ? AppDimens.space4 : 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.radiusStatus),
      ),
      child: Text(
        label,
        style: tokens.text.statusChip.copyWith(color: foreground),
      ),
    );
  }
}
