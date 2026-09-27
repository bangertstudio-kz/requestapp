import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/app_language.dart';
import '../domain/entities/app_theme_mode.dart';
import 'settings_repository.dart';

/// Настройки в `shared_preferences`.
///
/// Не в базе: пара значений, читаемых до первого кадра, не стоит миграции
/// схемы, а в режиме моков базы нет вовсе — язык же должен переживать
/// перезапуск в обоих режимах.
///
/// Экземпляр берётся на каждом вызове, а не в конструкторе: фабрика
/// собирается и в тестах, где платформенного хранилища нет, пока тест
/// сам его не подменит.
class PreferencesSettingsRepository implements SettingsRepository {
  const PreferencesSettingsRepository();

  @override
  Future<AppLanguage?> language() async {
    final name = (await SharedPreferences.getInstance()).getString(_language);
    return name == null ? null : AppLanguage.byName(name);
  }

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      _save(_language, language.name);

  @override
  Future<AppThemeMode?> theme() async {
    final name = (await SharedPreferences.getInstance()).getString(_theme);
    return name == null ? null : AppThemeMode.byName(name);
  }

  @override
  Future<void> saveTheme(AppThemeMode theme) => _save(_theme, theme.name);

  static Future<void> _save(String key, String value) async {
    final saved = await (await SharedPreferences.getInstance()).setString(
      key,
      value,
    );
    if (!saved) throw StateError('shared_preferences не записал «$key».');
  }

  static const _language = 'language';
  static const _theme = 'theme';
}
