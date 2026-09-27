import 'package:flutter_test/flutter_test.dart';
import 'package:request/core/presentation/app_text.dart';
import 'package:request/feature/settings/data/preferences_settings_repository.dart';
import 'package:request/feature/settings/domain/entities/app_language.dart';
import 'package:request/feature/settings/domain/entities/app_theme_mode.dart';
import 'package:request/feature/settings/presentation/language_notifier.dart';
import 'package:request/feature/settings/presentation/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const repository = PreferencesSettingsRepository();

  test('язык сохраняется и читается обратно', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await repository.language(), isNull);

    await repository.saveLanguage(AppLanguage.cat);
    expect(await repository.language(), AppLanguage.cat);
  });

  test('незнакомое значение в хранилище — как будто не выбирали', () async {
    SharedPreferences.setMockInitialValues({
      'language': 'klingon',
      'theme': 'sepia',
    });
    expect(await repository.language(), isNull);
    expect(await repository.theme(), isNull);
  });

  test('тема сохраняется отдельно от языка', () async {
    SharedPreferences.setMockInitialValues({});
    final notifier = ThemeNotifier(repository, AppThemeMode.light);
    addTearDown(notifier.dispose);

    await notifier.select(AppThemeMode.dark);
    await repository.saveLanguage(AppLanguage.kk);

    expect(notifier.value, AppThemeMode.dark);
    expect(await repository.theme(), AppThemeMode.dark);
    expect(await repository.language(), AppLanguage.kk);
  });

  test('смена языка переключает и фразы нотифаеров, и хранилище', () async {
    SharedPreferences.setMockInitialValues({});
    final notifier = LanguageNotifier(repository, AppLanguage.ru);
    addTearDown(notifier.dispose);
    expect(AppText.current.errorUnknown, startsWith('Что-то'));

    await notifier.select(AppLanguage.en);

    expect(notifier.value, AppLanguage.en);
    expect(AppText.current.errorUnknown, startsWith('Something'));
    expect(await repository.language(), AppLanguage.en);

    await notifier.select(AppLanguage.ru);
  });
}
