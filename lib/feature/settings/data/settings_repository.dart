import '../domain/entities/app_language.dart';

/// Настройки приложения на устройстве.
abstract interface class SettingsRepository {
  /// Выбранный язык или `null`, если его ещё не выбирали.
  Future<AppLanguage?> language();

  Future<void> saveLanguage(AppLanguage language);
}
