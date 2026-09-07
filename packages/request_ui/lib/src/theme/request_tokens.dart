import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import 'request_text_theme.dart';

/// Семантические токены приложения.
///
/// Виджет спрашивает у темы смысл («поверхность карточки»), а не значение
/// («#ffffff»). Поэтому расширение темы, а не набор глобальных констант:
/// значение зависит от того, какая тема сейчас надета.
@immutable
class RequestTokens extends ThemeExtension<RequestTokens> {
  const RequestTokens({
    required this.primary,
    required this.primaryPressed,
    required this.primaryTint,
    required this.primaryTintPressed,
    required this.primarySelected,
    required this.primaryDisabled,
    required this.borderSelectedSoft,
    required this.surface,
    required this.background,
    required this.surfaceHover,
    required this.surfaceMuted,
    required this.surfaceNeutral,
    required this.divider,
    required this.hover,
    required this.border,
    required this.borderStrong,
    required this.borderDashed,
    required this.borderButton,
    required this.borderHover,
    required this.ink,
    required this.inkChip,
    required this.inkSecondary,
    required this.inkTertiary,
    required this.inkMuted,
    required this.inkFaint,
    required this.inkDisabled,
    required this.danger,
    required this.dangerPressed,
    required this.dangerBorder,
    required this.dangerTint,
    required this.success,
    required this.successTint,
    required this.snackSurface,
    required this.snackInk,
    required this.text,
    required this.fabShadow,
    required this.sheetShadow,
    required this.snackShadow,
  });

  /// Светлая тема из макета. Тёмной в макете нет: см. [RequestTheme].
  factory RequestTokens.light() => RequestTokens(
          primary: AppColors.blue,
          primaryPressed: AppColors.blueDark,
          primaryTint: AppColors.blueTintSoft,
          primaryTintPressed: AppColors.blueTintSoftPressed,
          primarySelected: AppColors.blueTint,
          primaryDisabled: AppColors.blueMuted,
          borderSelectedSoft: AppColors.blueBorderSoft,
          surface: AppColors.white,
          background: AppColors.grey50,
          surfaceHover: AppColors.grey75,
          surfaceMuted: AppColors.grey100,
          surfaceNeutral: AppColors.grey150,
          divider: AppColors.grey200,
          hover: AppColors.grey250,
          border: AppColors.grey300,
          borderStrong: AppColors.grey350,
          borderDashed: AppColors.grey400,
          borderButton: AppColors.grey450,
          borderHover: AppColors.grey500,
          ink: AppColors.ink,
          inkChip: AppColors.ink700,
          inkSecondary: AppColors.ink600,
          inkTertiary: AppColors.ink500,
          inkMuted: AppColors.ink400,
          inkFaint: AppColors.ink300,
          inkDisabled: AppColors.ink200,
          danger: AppColors.red,
          dangerPressed: AppColors.redDark,
          dangerBorder: AppColors.redBorder,
          dangerTint: AppColors.redTint,
          success: AppColors.green,
          successTint: AppColors.greenTint,
          snackSurface: AppColors.snackSurface,
          snackInk: AppColors.snackInk,
        text: RequestTextTheme.standard(),
        fabShadow: const [
          BoxShadow(
            color: Color(0x5223558F),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
        sheetShadow: const [
          BoxShadow(
            color: Color(0x2914181A),
            blurRadius: 40,
            offset: Offset(0, -12),
          ),
        ],
        snackShadow: const [
          BoxShadow(
            color: Color(0x38000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      );

  /// Единственный акцент. Всё, что им покрашено, нажимается.
  final Color primary;

  final Color primaryPressed;

  /// Заливка «слабого» действия и подсветка нажатия по белому.
  final Color primaryTint;

  final Color primaryTintPressed;

  /// Фон выбранного: пилюля вкладки, выбранная строка, чип «Отправлена».
  final Color primarySelected;

  /// Синий без права нажатия — форма кнопки та же, обещание снято.
  final Color primaryDisabled;

  /// Граница раскрытой подкатегории.
  final Color borderSelectedSoft;

  /// Карточки, шторки, нижние панели.
  final Color surface;

  /// Фон экрана. Карточка на нём видна без тени.
  final Color background;

  final Color surfaceHover;

  /// Плашка единицы измерения в строке дерева.
  final Color surfaceMuted;

  /// Чип статуса «Черновик».
  final Color surfaceNeutral;

  /// Разделитель внутри карточки позиции.
  final Color divider;

  final Color hover;

  /// Рамка карточки по умолчанию.
  final Color border;

  /// Рамка кнопки-квадрата и ручка шторки.
  final Color borderStrong;

  /// Пунктир пустого состояния.
  final Color borderDashed;

  /// Рамка нейтральной кнопки.
  final Color borderButton;

  final Color borderHover;

  /// Основной текст.
  final Color ink;

  /// Текст невыбранного чипа.
  final Color inkChip;

  final Color inkSecondary;

  final Color inkTertiary;

  /// Подписи секций и вторая строка карточки.
  final Color inkMuted;

  /// Шеврон «внутрь».
  final Color inkFaint;

  /// Ноль на табло, пока количество не введено.
  final Color inkDisabled;

  /// Удаление.
  final Color danger;

  final Color dangerPressed;

  final Color dangerBorder;

  final Color dangerTint;

  /// Только чип «Сохранена».
  final Color success;

  final Color successTint;

  /// Снек инвертирован: он лежит поверх контента.
  final Color snackSurface;

  final Color snackInk;

  final RequestTextTheme text;

  /// Единственная тень, поднимающая элемент над контентом, — у плавающей
  /// кнопки; она синяя, а не серая, чтобы не выглядеть грязью под кнопкой.
  final List<BoxShadow> fabShadow;
  final List<BoxShadow> sheetShadow;
  final List<BoxShadow> snackShadow;

  @override
  RequestTokens copyWith({
    Color? primary,
    Color? primaryPressed,
    Color? primaryTint,
    Color? primaryTintPressed,
    Color? primarySelected,
    Color? primaryDisabled,
    Color? borderSelectedSoft,
    Color? surface,
    Color? background,
    Color? surfaceHover,
    Color? surfaceMuted,
    Color? surfaceNeutral,
    Color? divider,
    Color? hover,
    Color? border,
    Color? borderStrong,
    Color? borderDashed,
    Color? borderButton,
    Color? borderHover,
    Color? ink,
    Color? inkChip,
    Color? inkSecondary,
    Color? inkTertiary,
    Color? inkMuted,
    Color? inkFaint,
    Color? inkDisabled,
    Color? danger,
    Color? dangerPressed,
    Color? dangerBorder,
    Color? dangerTint,
    Color? success,
    Color? successTint,
    Color? snackSurface,
    Color? snackInk,
    RequestTextTheme? text,
    List<BoxShadow>? fabShadow,
    List<BoxShadow>? sheetShadow,
    List<BoxShadow>? snackShadow,
  }) =>
      RequestTokens(
        primary: primary ?? this.primary,
        primaryPressed: primaryPressed ?? this.primaryPressed,
        primaryTint: primaryTint ?? this.primaryTint,
        primaryTintPressed: primaryTintPressed ?? this.primaryTintPressed,
        primarySelected: primarySelected ?? this.primarySelected,
        primaryDisabled: primaryDisabled ?? this.primaryDisabled,
        borderSelectedSoft: borderSelectedSoft ?? this.borderSelectedSoft,
        surface: surface ?? this.surface,
        background: background ?? this.background,
        surfaceHover: surfaceHover ?? this.surfaceHover,
        surfaceMuted: surfaceMuted ?? this.surfaceMuted,
        surfaceNeutral: surfaceNeutral ?? this.surfaceNeutral,
        divider: divider ?? this.divider,
        hover: hover ?? this.hover,
        border: border ?? this.border,
        borderStrong: borderStrong ?? this.borderStrong,
        borderDashed: borderDashed ?? this.borderDashed,
        borderButton: borderButton ?? this.borderButton,
        borderHover: borderHover ?? this.borderHover,
        ink: ink ?? this.ink,
        inkChip: inkChip ?? this.inkChip,
        inkSecondary: inkSecondary ?? this.inkSecondary,
        inkTertiary: inkTertiary ?? this.inkTertiary,
        inkMuted: inkMuted ?? this.inkMuted,
        inkFaint: inkFaint ?? this.inkFaint,
        inkDisabled: inkDisabled ?? this.inkDisabled,
        danger: danger ?? this.danger,
        dangerPressed: dangerPressed ?? this.dangerPressed,
        dangerBorder: dangerBorder ?? this.dangerBorder,
        dangerTint: dangerTint ?? this.dangerTint,
        success: success ?? this.success,
        successTint: successTint ?? this.successTint,
        snackSurface: snackSurface ?? this.snackSurface,
        snackInk: snackInk ?? this.snackInk,
        text: text ?? this.text,
        fabShadow: fabShadow ?? this.fabShadow,
        sheetShadow: sheetShadow ?? this.sheetShadow,
        snackShadow: snackShadow ?? this.snackShadow,
      );

  @override
  RequestTokens lerp(covariant RequestTokens? other, double t) {
    if (other == null) return this;
    return RequestTokens(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryTint: Color.lerp(primaryTint, other.primaryTint, t)!,
      primaryTintPressed: Color.lerp(primaryTintPressed, other.primaryTintPressed, t)!,
      primarySelected: Color.lerp(primarySelected, other.primarySelected, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      borderSelectedSoft: Color.lerp(borderSelectedSoft, other.borderSelectedSoft, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceNeutral: Color.lerp(surfaceNeutral, other.surfaceNeutral, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      hover: Color.lerp(hover, other.hover, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderDashed: Color.lerp(borderDashed, other.borderDashed, t)!,
      borderButton: Color.lerp(borderButton, other.borderButton, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkChip: Color.lerp(inkChip, other.inkChip, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      inkTertiary: Color.lerp(inkTertiary, other.inkTertiary, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      inkDisabled: Color.lerp(inkDisabled, other.inkDisabled, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerPressed: Color.lerp(dangerPressed, other.dangerPressed, t)!,
      dangerBorder: Color.lerp(dangerBorder, other.dangerBorder, t)!,
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t)!,
      success: Color.lerp(success, other.success, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      snackSurface: Color.lerp(snackSurface, other.snackSurface, t)!,
      snackInk: Color.lerp(snackInk, other.snackInk, t)!,
      // Текст и тени не интерполируются: тема в приложении одна, а половина
      // размера шрифта на середине анимации — это дрожащая вёрстка.
      text: t < 0.5 ? text : other.text,
      fabShadow: t < 0.5 ? fabShadow : other.fabShadow,
      sheetShadow: t < 0.5 ? sheetShadow : other.sheetShadow,
      snackShadow: t < 0.5 ? snackShadow : other.snackShadow,
    );
  }
}

/// Короткий доступ к токенам из `build`.
extension RequestTokensX on BuildContext {
  /// Токены текущей темы. Бросает, если [RequestTokens] не подмешаны в
  /// `ThemeData.extensions` — молчаливый фолбэк на дефолтную палитру
  /// прятал бы ошибку сборки темы до самого ревью макета.
  RequestTokens get request {
    final tokens = Theme.of(this).extension<RequestTokens>();
    assert(
      tokens != null,
      'RequestTokens не найдены в теме. Используйте RequestTheme.light.',
    );
    return tokens ?? RequestTokens.light();
  }
}
