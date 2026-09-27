import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/typography.dart';
import 'request_tokens.dart';

/// Темы приложения.
///
/// Светлая — из макета («Android · Material 3 · Light»). Тёмной в макете
/// нет: её роли те же, палитра подобрана по светлой (см. [AppDarkColors]),
/// и до того как её нарисуют, это приближение, а не решение дизайнера.
abstract final class RequestTheme {
  static ThemeData get light => _build(
    RequestTokens.light(),
    ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      // Заданные явно роли важнее подобранных генератором: карточка обязана
      // быть белой на сером фоне, иначе исчезает граница между ними.
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      surface: AppColors.grey50,
      onSurface: AppColors.ink,
      error: AppColors.red,
      onError: AppColors.white,
    ),
  );

  static ThemeData get dark => _build(
    RequestTokens.dark(),
    ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.dark,
      primary: AppDarkColors.blue,
      onPrimary: AppDarkColors.surface,
      surface: AppDarkColors.background,
      onSurface: AppDarkColors.ink,
      error: AppDarkColors.red,
      onError: AppDarkColors.surface,
    ),
  );

  static ThemeData _build(RequestTokens tokens, ColorScheme scheme) =>
      ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        // Фон экрана берётся отсюда, и экраны его не переопределяют.
        // `Scaffold(backgroundColor: Colors.transparent)` внутри маршрута —
        // это чёрный экран на устройстве: за маршрутом ничего не нарисовано,
        // а прозрачность в golden-PNG выглядит белой и потому не замечается.
        scaffoldBackgroundColor: tokens.background,
        canvasColor: tokens.background,
        splashFactory: InkSparkle.splashFactory,
        fontFamily: AppFonts.sans,
        fontFamilyFallback: const [AppFonts.sans],
        extensions: [tokens],
        textTheme: _textTheme(tokens),
        // Курсор и выделение в полях — тем же акцентом: другого в макете нет.
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: tokens.primary,
          selectionColor: tokens.primarySelected,
          selectionHandleColor: tokens.primary,
        ),
      );

  /// Материаловские роли отображены на роли макета, чтобы стандартные виджеты
  /// (диалоги, тултипы, текст без стиля) не выпадали из гарнитуры.
  static TextTheme _textTheme(RequestTokens tokens) {
    final text = tokens.text;
    return TextTheme(
      headlineSmall: text.appBarTitle,
      titleLarge: text.appBarTitle,
      titleMedium: text.cardTitle,
      titleSmall: text.itemTitle,
      bodyLarge: text.body,
      bodyMedium: text.body,
      bodySmall: text.bodySmall,
      labelLarge: text.buttonLarge,
      labelMedium: text.chip,
      labelSmall: text.sectionLabel,
    );
  }
}
