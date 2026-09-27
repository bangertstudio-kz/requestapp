import 'package:flutter/foundation.dart';

import '../data/settings_repository.dart';
import '../domain/entities/app_theme_mode.dart';

/// Текущая тема оформления. Как и язык, меняется сразу, запись — следом.
class ThemeNotifier extends ValueNotifier<AppThemeMode> {
  ThemeNotifier(this._repository, super.value);

  final SettingsRepository _repository;

  /// Переключает тему и сохраняет выбор. Бросает, если записать не удалось:
  /// тема при этом уже сменена и продержится до перезапуска.
  Future<void> select(AppThemeMode theme) async {
    if (theme == value) return;
    value = theme;
    await _repository.saveTheme(theme);
  }
}
