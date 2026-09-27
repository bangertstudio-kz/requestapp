import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/app_language.dart';

/// Настройки: пока только язык интерфейса.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.language,
    required this.onLanguageSelected,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageSelected;

  /// Название языка на нём самом, а не на текущем: человек, случайно
  /// включивший кошачий, должен узнать «Русский», не понимая ни слова вокруг.
  static String _nameOf(AppLocalizations l10n, AppLanguage language) =>
      switch (language) {
        AppLanguage.ru => l10n.languageRussian,
        AppLanguage.en => l10n.languageEnglish,
        AppLanguage.kk => l10n.languageKazakh,
        AppLanguage.cat => l10n.languageCat,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.settingsTitle,
                subtitle: l10n.settingsSubtitle,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.labelPadding,
                  AppDimens.space2,
                  AppDimens.labelPadding,
                  AppDimens.space8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppSectionLabel(l10n.settingsLanguageLabel),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    0,
                    AppDimens.screenPadding,
                    AppDimens.space26,
                  ),
                  itemCount: AppLanguage.values.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimens.space8),
                  itemBuilder: (context, index) {
                    final value = AppLanguage.values[index];
                    final selected = value == language;
                    return Semantics(
                      selected: selected,
                      inMutuallyExclusiveGroup: true,
                      child: AppCard(
                        borderRadius: AppDimens.radiusControl,
                        borderColor: selected ? tokens.primary : null,
                        minHeight: 56,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: AppDimens.space12,
                        ),
                        onTap: () => onLanguageSelected(value),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _nameOf(l10n, value),
                                style: tokens.text.rowTitle,
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check,
                                size: 20,
                                color: tokens.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
