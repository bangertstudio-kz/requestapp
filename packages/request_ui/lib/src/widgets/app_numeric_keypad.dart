import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Клавиша цифровой клавиатуры.
sealed class AppKeypadKey {
  const AppKeypadKey();
}

/// Цифра или группа цифр («00»), дописываемая в конец значения.
class AppKeypadDigits extends AppKeypadKey {
  const AppKeypadDigits(this.digits);

  final String digits;
}

/// Стирание последнего символа.
class AppKeypadBackspace extends AppKeypadKey {
  const AppKeypadBackspace();
}

/// Клавиатура для ввода количества.
///
/// Своя, а не системная: количество здесь всегда целое, и системная
/// клавиатура ради этого закрывала бы половину экрана вместе с самим
/// материалом, к которому это количество относится.
class AppNumericKeypad extends StatelessWidget {
  const AppNumericKeypad({
    super.key,
    required this.onKey,
    required this.backspaceSemanticLabel,
    this.compact = false,
  });

  final ValueChanged<AppKeypadKey> onKey;

  /// «⌫» в IBM Plex отсутствует, клавиша рисуется иконкой — значит, ей нужна
  /// подпись для скринридера, и она приходит из ARB.
  final String backspaceSemanticLabel;

  /// В шторке клавиши ниже: там над ними ещё карточка материала и табло.
  final bool compact;

  static const List<AppKeypadKey> _keys = [
    AppKeypadDigits('1'),
    AppKeypadDigits('2'),
    AppKeypadDigits('3'),
    AppKeypadDigits('4'),
    AppKeypadDigits('5'),
    AppKeypadDigits('6'),
    AppKeypadDigits('7'),
    AppKeypadDigits('8'),
    AppKeypadDigits('9'),
    AppKeypadDigits('00'),
    AppKeypadDigits('0'),
    AppKeypadBackspace(),
  ];

  @override
  Widget build(BuildContext context) {
    final spacing = compact ? 7.0 : AppDimens.space8;
    final height = compact ? AppDimens.keyHeightCompact : AppDimens.keyHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final key in _keys)
              SizedBox(
                width: width,
                height: height,
                child: _Key(
                  value: key,
                  compact: compact,
                  backspaceSemanticLabel: backspaceSemanticLabel,
                  onTap: () => onKey(key),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.value,
    required this.compact,
    required this.backspaceSemanticLabel,
    required this.onTap,
  });

  final AppKeypadKey value;
  final bool compact;
  final String backspaceSemanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(
      compact ? AppDimens.radiusButton : AppDimens.radiusControl,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: radius,
        border: Border.all(color: tokens.borderStrong),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Center(
            child: switch (value) {
              AppKeypadDigits(:final digits) => Text(
                  digits,
                  style: compact
                      ? tokens.text.keypadKeyCompact
                      : tokens.text.keypadKey,
                ),
              AppKeypadBackspace() => Icon(
                  Icons.backspace_outlined,
                  size: 20,
                  color: tokens.ink,
                  semanticLabel: backspaceSemanticLabel,
                ),
            },
          ),
        ),
      ),
    );
  }
}
