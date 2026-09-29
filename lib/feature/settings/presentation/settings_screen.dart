import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';

/// Настройки: одна карточка, по строке на настройку.
///
/// Строка показывает текущее значение, а варианты — в шторке по нажатию:
/// выбор делают раз в жизни, и держать все семь вариантов на экране
/// постоянно — место, отданное тому, на что не смотрят.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.languageName,
    required this.onLanguageTap,
    required this.themeName,
    required this.onThemeTap,
    required this.onPrivacyTap,
  });

  final String languageName;
  final VoidCallback onLanguageTap;
  final String themeName;
  final VoidCallback onThemeTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    // Волна нажатия рисуется на материале карточки и сама по её углам
    // не обрезается: крайним строкам нужен тот же радиус, что у карточки.
    const radius = Radius.circular(AppDimens.radiusControl);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTopBar(
                title: l10n.settingsTitle,
                subtitle: l10n.settingsSubtitle,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  AppDimens.space2,
                  AppDimens.screenPadding,
                  0,
                ),
                child: AppCard(
                  borderRadius: AppDimens.radiusControl,
                  child: Column(
                    children: [
                      _SettingRow(
                        label: l10n.settingsLanguageLabel,
                        value: languageName,
                        borderRadius: const BorderRadius.vertical(top: radius),
                        onTap: onLanguageTap,
                      ),
                      Divider(height: 1, thickness: 1, color: tokens.divider),
                      _SettingRow(
                        label: l10n.settingsThemeLabel,
                        value: themeName,
                        borderRadius: const BorderRadius.vertical(
                          bottom: radius,
                        ),
                        onTap: onThemeTap,
                      ),
                    ],
                  ),
                ),
              ),
              // Отдельной карточкой: это не настройка, а ссылка наружу.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  AppDimens.space8,
                  AppDimens.screenPadding,
                  0,
                ),
                child: AppCard(
                  borderRadius: AppDimens.radiusControl,
                  child: _SettingRow(
                    label: l10n.settingsPrivacyPolicy,
                    borderRadius: const BorderRadius.all(radius),
                    onTap: onPrivacyTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// «Название · значение ›» — строка, открывающая выбор.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.value,
    required this.borderRadius,
    required this.onTap,
  });

  final String label;

  /// Нет значения — строка просто ведёт дальше, как ссылка.
  final String? value;

  /// Скругление волны нажатия: совпадает с углами карточки у крайних строк.
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, AppDimens.space8, 0),
          child: Row(
            children: [
              Expanded(child: Text(label, style: tokens.text.rowTitle)),
              if (value case final value?)
                Text(value, style: tokens.text.caption),
              const SizedBox(width: AppDimens.space2),
              Icon(Icons.chevron_right, size: 20, color: tokens.inkFaint),
            ],
          ),
        ),
      ),
    );
  }
}
