import 'dart:ui';

import '../../generated/app_localizations.dart';

/// Активные локализации для слоя без `BuildContext`.
///
/// Нотифаеры живут дольше экранов, `AppLocalizations.of` им недоступен,
/// а превращать ошибку в фразу — их работа. Намеренно один изменяемый холдер,
/// а не аргумент конструктора: протаскивать локаль через два десятка
/// нотифаеров ради тех нескольких, что падают, — правка всех ради немногих.
abstract final class AppText {
  static Locale _locale = const Locale('ru');

  /// Выставляется в `main` до первого кадра и при смене языка.
  static set locale(Locale value) => _locale = value;

  static AppLocalizations get current => lookupAppLocalizations(_locale);
}
