import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/presentation/app_text.dart';
import '../../../core/presentation/failure_message.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/tab_shell.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/app_language.dart';
import '../domain/entities/app_theme_mode.dart';
import 'choice_sheet.dart';
import 'language_notifier.dart';
import 'settings_screen.dart';
import 'theme_notifier.dart';

/// Вкладка настроек.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Название языка на нём самом, а не на текущем: человек, случайно
  /// включивший кошачий, должен узнать «Русский», не понимая ни слова вокруг.
  static String _languageName(AppLocalizations l10n, AppLanguage language) =>
      switch (language) {
        AppLanguage.ru => l10n.languageRussian,
        AppLanguage.en => l10n.languageEnglish,
        AppLanguage.kk => l10n.languageKazakh,
        AppLanguage.cat => l10n.languageCat,
      };

  static String _themeName(AppLocalizations l10n, AppThemeMode theme) =>
      switch (theme) {
        AppThemeMode.system => l10n.themeSystem,
        AppThemeMode.light => l10n.themeLight,
        AppThemeMode.dark => l10n.themeDark,
      };

  Future<void> _pickLanguage(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<LanguageNotifier>(context);
    final picked = await ChoiceSheet.show<AppLanguage>(
      context,
      title: l10n.settingsLanguageLabel,
      options: [
        for (final value in AppLanguage.values)
          (value, _languageName(l10n, value)),
      ],
      selected: notifier.value,
    );
    if (picked == null || !context.mounted) return;
    await _save(context, () => notifier.select(picked));
  }

  Future<void> _pickTheme(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<ThemeNotifier>(context);
    final picked = await ChoiceSheet.show<AppThemeMode>(
      context,
      title: l10n.settingsThemeLabel,
      options: [
        for (final value in AppThemeMode.values)
          (value, _themeName(l10n, value)),
      ],
      selected: notifier.value,
    );
    if (picked == null || !context.mounted) return;
    await _save(context, () => notifier.select(picked));
  }

  /// Страница лежит рядом с веб-версией на GitHub Pages (web/privacy.html).
  static final _privacyPolicy = Uri.parse(
    'https://bangertstudio-kz.github.io/requestapp/privacy.html',
  );

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final snack = NotifierScope.read<SnackNotifier>(context);
    try {
      if (!await launchUrl(_privacyPolicy)) {
        snack.show(AppText.current.errorPlatform);
      }
    } catch (error) {
      snack.show(failureMessage(AppText.current, error));
    }
  }

  /// Выбор применяется сразу; не записался — говорим, что после перезапуска
  /// вернётся прежний.
  Future<void> _save(
    BuildContext context,
    Future<void> Function() select,
  ) async {
    final snack = NotifierScope.read<SnackNotifier>(context);
    try {
      await select();
    } catch (error) {
      snack.show(failureMessage(AppText.current, error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TabShell(
      index: 2,
      child: SettingsScreen(
        languageName: _languageName(
          l10n,
          NotifierScope.of<LanguageNotifier>(context).value,
        ),
        onLanguageTap: () => _pickLanguage(context),
        themeName: _themeName(
          l10n,
          NotifierScope.of<ThemeNotifier>(context).value,
        ),
        onThemeTap: () => _pickTheme(context),
        onPrivacyTap: () => _openPrivacyPolicy(context),
      ),
    );
  }
}
