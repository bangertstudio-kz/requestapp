import 'package:flutter/material.dart';

/// Тема оформления. Своё перечисление поверх [ThemeMode] — по той же причине,
/// что у языка: в хранилище лежит имя значения, а не деталь фреймворка.
enum AppThemeMode {
  system(ThemeMode.system),
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  const AppThemeMode(this.mode);

  final ThemeMode mode;

  /// Тема по имени из хранилища; незнакомое — `null`.
  static AppThemeMode? byName(String name) =>
      values.where((value) => value.name == name).firstOrNull;
}
