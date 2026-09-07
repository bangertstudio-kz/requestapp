import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/typography.dart';
import 'request_tokens.dart';

/// Темы приложения.
///
/// Тёмной темы здесь нет намеренно. Макет («Android · Material 3 · Light»)
/// описывает только светлую, а придуманная тёмная — это набор цветов, которых
/// никто не смотрел; её лучше завести тогда, когда её нарисуют.
abstract final class RequestTheme {
  static ThemeData get light {
    final tokens = RequestTokens.light();
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      // Заданные явно роли важнее подобранных генератором: карточка обязана
      // быть белой на сером фоне, иначе исчезает граница между ними.
      primary: AppColors.blue,
      onPrimary: AppColors.white,
      surface: AppColors.grey50,
      onSurface: AppColors.ink,
      error: AppColors.red,
      onError: AppColors.white,
    );

    return ThemeData(
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
  }

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
