import 'package:flutter/foundation.dart';

import '../../../core/presentation/app_text.dart';
import '../data/settings_repository.dart';
import '../domain/entities/app_language.dart';

/// Текущий язык интерфейса.
///
/// Не `RequestNotifier`: язык меняется сразу, по нажатию, и ждать записи
/// на диск, чтобы перерисовать экран, незачем. Запись — следом.
class LanguageNotifier extends ValueNotifier<AppLanguage> {
  LanguageNotifier(this._repository, super.value) {
    AppText.locale = value.locale;
  }

  final SettingsRepository _repository;

  /// Переключает язык и сохраняет выбор. Бросает, если записать не удалось:
  /// язык при этом уже сменён и продержится до перезапуска.
  Future<void> select(AppLanguage language) async {
    if (language == value) return;
    AppText.locale = language.locale;
    value = language;
    await _repository.saveLanguage(language);
  }
}
