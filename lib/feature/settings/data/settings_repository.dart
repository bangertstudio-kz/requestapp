import '../domain/entities/app_language.dart';
import '../domain/entities/app_theme_mode.dart';

/// Настройки приложения на устройстве.
abstract interface class SettingsRepository {
  /// Выбранный язык или `null`, если его ещё не выбирали.
  Future<AppLanguage?> language();

  Future<void> saveLanguage(AppLanguage language);

  /// Выбранная тема или `null`, если её ещё не выбирали.
  Future<AppThemeMode?> theme();

  Future<void> saveTheme(AppThemeMode theme);
}
