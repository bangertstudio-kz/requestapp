import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Высота кнопки. Радиус и текстовый стиль следуют за высотой: в макете они
/// меняются вместе, и разрешать их комбинировать — значит разрешить кнопку
/// 54 pt с радиусом 10, которой в макете нет.
enum AppButtonSize {
  /// Главное действие экрана и нижних панелей.
  large(AppDimens.buttonLarge, AppDimens.radiusCard),

  /// Парные действия в нижней панели заявки.
  medium(AppDimens.buttonMedium, AppDimens.radiusControl),

  /// Действие внутри карточки («Заменить материал»).
  compact(44, AppDimens.radiusButton),

  /// Действие в строке списка («Удалить», «Изм.»). Высота 44, а не 40 из
  /// макета: у этих кнопок нет рамки, поэтому лишние четыре точки не видны,
  /// а зона нажатия дотягивает до минимума.
  small(AppDimens.buttonSmall, AppDimens.radiusButtonSmall);

  const AppButtonSize(this.height, this.radius);

  final double height;
  final double radius;
}

/// Кнопка дизайн-системы.
///
/// Именованные конструкторы вместо `variant`-параметра: набор сочетаний
/// «фон + рамка + цвет текста» в макете закрыт, и открывать его свободным
/// перечислением цветов значит через месяц получить седьмой оттенок синего.
class AppButton extends StatelessWidget {
  const AppButton._(
    this._kind, {
    super.key,
    required this.label,
    required this.onPressed,
    required this.size,
    required this.icon,
    required this.expanded,
    this.width,
  });

  /// Главное действие: сплошная заливка акцентом.
  const AppButton.filled({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.large,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.filled,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Действие второго ряда: акцент в заливке и в рамке, но негромко.
  const AppButton.tonal({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.tonal,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Отказ от действия: белая кнопка с нейтральной рамкой.
  const AppButton.outlined({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.large,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.outlined,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Белая кнопка, но действие ведёт дальше по сценарию — текст акцентный.
  const AppButton.outlinedAccent({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.compact,
    IconData? icon,
    bool expanded = false,
    double? width,
  }) : this._(
          _AppButtonKind.outlinedAccent,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Удаление, предложенное — но ещё не подтверждённое.
  const AppButton.dangerOutlined({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.dangerOutlined,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Подтверждение удаления. Единственная сплошная красная кнопка в макете.
  const AppButton.dangerFilled({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.large,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.dangerFilled,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Действие без веса: «+ Папка», «Изм.», «Отмена» в шторке.
  const AppButton.text({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.small,
    IconData? icon,
    bool expanded = false,
    double? width,
  }) : this._(
          _AppButtonKind.text,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// «Удалить» внутри карточки позиции: без рамки, но красным.
  const AppButton.dangerText({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.small,
    IconData? icon,
    bool expanded = false,
    double? width,
  }) : this._(
          _AppButtonKind.dangerText,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  /// Нейтральное «Отмена» в шторке — без акцента и без рамки.
  const AppButton.neutralText({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool expanded = true,
    double? width,
  }) : this._(
          _AppButtonKind.neutralText,
          key: key,
          label: label,
          onPressed: onPressed,
          size: size,
          icon: icon,
          expanded: expanded,
          width: width,
        );

  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final IconData? icon;

  /// Растянуть на всю доступную ширину. Для кнопок в `Row` вызывающий
  /// оборачивает в `Expanded` сам — соотношения (1.6 к 1) живут в макете
  /// экрана, а не в кнопке.
  final bool expanded;
  final double? width;

  final _AppButtonKind _kind;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final enabled = onPressed != null;
    final style = _kind.resolve(tokens, enabled: enabled);
    final radius = BorderRadius.circular(size.radius);

    final textStyle = switch (size) {
      AppButtonSize.large => tokens.text.buttonLarge,
      AppButtonSize.medium => _kind.isQuiet
          ? tokens.text.buttonMedium
          : tokens.text.buttonCompact,
      AppButtonSize.compact => tokens.text.buttonCompact,
      AppButtonSize.small => tokens.text.buttonText,
    };

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: style.foreground),
          const SizedBox(width: AppDimens.space10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle.copyWith(color: style.foreground),
          ),
        ),
      ],
    );

    final button = SizedBox(
      height: size.height,
      width: width ?? (expanded ? double.infinity : null),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: radius,
          border: style.border == null
              ? null
              : Border.all(color: style.border!, width: style.borderWidth),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _kind.horizontalPadding),
              // Та же ловушка, что и у чипа: `Center` без множителя занимает
              // всю доступную ширину, и кнопка, которая должна быть по
              // размеру надписи, растягивается на всю карточку. Там, где
              // ширина задана (`expanded`/`width`), жёсткие констрейнты
              // `SizedBox` всё равно сильнее множителя.
              child: Center(widthFactor: 1, child: content),
            ),
          ),
        ),
      ),
    );

    return button;
  }
}

enum _AppButtonKind {
  filled,
  tonal,
  outlined,
  outlinedAccent,
  dangerOutlined,
  dangerFilled,
  text,
  dangerText,
  neutralText;

  /// У кнопок без рамки поле уже: они стоят вплотную к краю карточки.
  double get horizontalPadding => switch (this) {
        text || dangerText || neutralText => AppDimens.space12,
        _ => AppDimens.space16,
      };

  bool get isQuiet =>
      this == outlined || this == text || this == neutralText;

  _AppButtonStyle resolve(RequestTokens tokens, {required bool enabled}) {
    // Недоступная кнопка не исчезает и не сереет целиком: она сохраняет форму
    // и теряет насыщенность. Так видно, что действие есть, но пока не готово.
    if (!enabled) {
      return switch (this) {
        filled => _AppButtonStyle(
            background: tokens.primaryDisabled,
            foreground: tokens.surface,
          ),
        dangerFilled => _AppButtonStyle(
            background: tokens.primaryDisabled,
            foreground: tokens.surface,
          ),
        _ => _AppButtonStyle(
            background: tokens.surface,
            foreground: tokens.inkDisabled,
            border: tokens.borderStrong,
          ),
      };
    }

    return switch (this) {
      filled => _AppButtonStyle(
          background: tokens.primary,
          foreground: tokens.surface,
        ),
      tonal => _AppButtonStyle(
          background: tokens.primaryTint,
          foreground: tokens.primary,
          border: tokens.primary,
          borderWidth: 1.5,
        ),
      outlined => _AppButtonStyle(
          background: tokens.surface,
          foreground: tokens.ink,
          border: tokens.borderButton,
        ),
      outlinedAccent => _AppButtonStyle(
          background: tokens.surface,
          foreground: tokens.primary,
          border: tokens.borderButton,
        ),
      dangerOutlined => _AppButtonStyle(
          background: tokens.surface,
          foreground: tokens.danger,
          border: tokens.dangerBorder,
        ),
      dangerFilled => _AppButtonStyle(
          background: tokens.danger,
          foreground: tokens.surface,
        ),
      text => _AppButtonStyle(
          background: Colors.transparent,
          foreground: tokens.primary,
        ),
      dangerText => _AppButtonStyle(
          background: Colors.transparent,
          foreground: tokens.danger,
        ),
      neutralText => _AppButtonStyle(
          background: Colors.transparent,
          foreground: tokens.inkSecondary,
        ),
    };
  }
}

class _AppButtonStyle {
  const _AppButtonStyle({
    required this.background,
    required this.foreground,
    this.border,
    this.borderWidth = 1,
  });

  final Color background;
  final Color foreground;
  final Color? border;
  final double borderWidth;
}
