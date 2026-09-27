import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/app_language.dart';
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
  Future<void> saveLanguage(AppLanguage language) async {
    final saved = await (await SharedPreferences.getInstance()).setString(
      _language,
      language.name,
    );
    if (!saved) throw StateError('shared_preferences не записал язык.');
  }

  static const _language = 'language';
}
