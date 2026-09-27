import 'package:flutter/material.dart';

import '../../../core/presentation/app_text.dart';
import '../../../core/presentation/failure_message.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/tab_shell.dart';
import '../domain/entities/app_language.dart';
import 'language_notifier.dart';
import 'settings_screen.dart';

/// Вкладка настроек.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _select(BuildContext context, AppLanguage language) async {
    final snack = NotifierScope.read<SnackNotifier>(context);
    try {
      await NotifierScope.read<LanguageNotifier>(context).select(language);
    } catch (error) {
      // Язык уже переключён — не записался только выбор, и после
      // перезапуска вернётся прежний. Об этом и надо сказать.
      snack.show(failureMessage(AppText.current, error));
    }
  }

  @override
  Widget build(BuildContext context) => TabShell(
    index: 2,
    child: SettingsScreen(
      language: NotifierScope.of<LanguageNotifier>(context).value,
      onLanguageSelected: (language) => _select(context, language),
    ),
  );
}
