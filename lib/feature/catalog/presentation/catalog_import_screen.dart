import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_import_summary.dart';

/// Обновление справочника из файла прайса.
///
/// Источник истины у заказчика — Excel, а не приложение: ручное создание
/// категорий существует для правок, импорт — для нормального обновления.
/// Поэтому экран построен как «разбор → отчёт → подтверждение», а не как
/// кнопка «загрузить»: заменять 326 материалов вслепую нельзя.
class CatalogImportScreen extends StatelessWidget {
  const CatalogImportScreen({
    super.key,
    required this.summary,
    required this.parsing,
    required this.errorMessage,
    required this.onPickFile,
    required this.onApply,
    required this.onBack,
  });

  /// Разобранный файл или `null` — файл ещё не выбран.
  final CatalogImportSummary? summary;

  /// Идёт разбор. Отдельный флаг, а не `summary == null`: между выбором файла
  /// и отчётом проходит заметное время, и экран обязан это показать.
  final bool parsing;

  /// Готовая фраза об ошибке разбора. Превращать исключение в текст — работа
  /// нотифаера; экран только рисует то, что ему дали.
  final String? errorMessage;

  final VoidCallback onPickFile;

  /// Подтверждение замены спрашивает вызывающий: это необратимое действие,
  /// и шторка подтверждения принадлежит сценарию, а не экрану.
  final VoidCallback onApply;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parsed = summary;

    return Scaffold(
      bottomNavigationBar: parsed == null
          ? null
          : _ApplyBar(onCancel: onBack, onApply: onApply),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.catalogImportTitle,
                subtitle: l10n.catalogImportSubtitle,
                onBack: onBack,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    AppDimens.space6,
                    AppDimens.screenPadding,
                    AppDimens.space26,
                  ),
                  children: switch ((parsed, parsing, errorMessage)) {
                    (_, true, _) => [const _Parsing()],
                    (_, _, final String message) => [
                      _Failure(message: message, onRetry: onPickFile),
                    ],
                    (null, _, _) => [_Intro(onPickFile: onPickFile)],
                    (final CatalogImportSummary value, _, _) => [
                      _Report(summary: value, onPickAnother: onPickFile),
                    ],
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

/// Файл ещё не выбран: объясняем, что произойдёт, и предлагаем выбрать.
class _Intro extends StatelessWidget {
  const _Intro({required this.onPickFile});

  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.catalogImportIntro, style: tokens.text.sheetSubtitle),
          const SizedBox(height: AppDimens.space12),
          Text(l10n.catalogImportFormats, style: tokens.text.caption),
          const SizedBox(height: AppDimens.space16),
          AppButton.filled(
            label: l10n.catalogImportPickFile,
            icon: Icons.upload_file_outlined,
            onPressed: onPickFile,
          ),
        ],
      ),
    );
  }
}

class _Parsing extends StatelessWidget {
  const _Parsing();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      padding: const EdgeInsets.all(AppDimens.space18),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: tokens.primary,
            ),
          ),
          const SizedBox(width: AppDimens.space14),
          Expanded(
            child: Text(l10n.catalogImportParsing, style: tokens.text.rowTitle),
          ),
        ],
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      // Красная рамка, но не красная заливка: файл не тот — это поправимо,
      // а залитая красным карточка читается как поломка приложения.
      borderColor: tokens.dangerBorder,
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: tokens.text.sheetSubtitle.copyWith(color: tokens.danger),
          ),
          const SizedBox(height: AppDimens.space14),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton.outlinedAccent(
              label: l10n.catalogImportPickAnother,
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}

/// Отчёт о разборе: что загрузится и что при этом пришлось поправить.
class _Report extends StatelessWidget {
  const _Report({required this.summary, required this.onPickAnother});

  final CatalogImportSummary summary;
  final VoidCallback onPickAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space14,
            vertical: AppDimens.space12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSectionLabel(l10n.catalogImportFileLabel),
              const SizedBox(height: AppDimens.space4),
              // Имя файла на всю ширину и в две строки: у прайсов заказчика
              // имена длинные и различаются в конце («…-SergeyM 2.xlsx»),
              // а обрезка с многоточием прячет ровно эту часть.
              Text(
                summary.fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.rowTitle,
              ),
              const SizedBox(height: AppDimens.space4),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton.text(
                  label: l10n.catalogImportPickAnother,
                  onPressed: onPickAnother,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.space12),
        AppCard(
          padding: const EdgeInsets.all(AppDimens.space14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSectionLabel(l10n.catalogImportStatsLabel),
              const SizedBox(height: AppDimens.space10),
              _Stat(
                label: l10n.catalogImportCategories,
                value: summary.categories,
              ),
              _Stat(
                label: l10n.catalogImportSubcategories,
                value: summary.subcategories,
              ),
              _Stat(
                label: l10n.catalogImportMaterials,
                value: summary.materials,
                emphasized: true,
              ),
            ],
          ),
        ),
        if (summary.hasWarnings) ...[
          const SizedBox(height: AppDimens.space12),
          AppCard(
            padding: const EdgeInsets.all(AppDimens.space14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSectionLabel(l10n.catalogImportWarningsLabel),
                const SizedBox(height: AppDimens.space10),
                // Предупреждения перечислены, а не свёрнуты в счётчик:
                // «6 замечаний» не даёт решить, грузить файл или чинить прайс.
                if (summary.duplicatesRemoved > 0)
                  _Warning(
                    text: l10n.catalogImportDuplicates(
                      summary.duplicatesRemoved,
                    ),
                  ),
                if (summary.rowsTrimmed > 0)
                  _Warning(
                    text: l10n.catalogImportTrimmed(summary.rowsTrimmed),
                  ),
                if (summary.rowsSkipped > 0)
                  _Warning(
                    text: l10n.catalogImportSkipped(summary.rowsSkipped),
                  ),
                if (summary.unknownUnits.isNotEmpty)
                  _Warning(
                    severe: true,
                    text: l10n.catalogImportUnknownUnits(
                      summary.unknownUnits.join(', '),
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppDimens.space12),
        Text(l10n.catalogImportReplaceNote, style: tokens.text.caption),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final int value;

  /// Число материалов — то, ради чего экран открыт; остальные две строки
  /// объясняют его структуру.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasized ? tokens.text.itemTitle : tokens.text.rowTitle,
            ),
          ),
          Text(
            l10n.requestFolderCount(value),
            style: emphasized
                ? tokens.text.quantityValue
                : tokens.text.meta.copyWith(color: tokens.ink),
          ),
        ],
      ),
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({required this.text, this.severe = false});

  final String text;

  /// Неизвестная единица означает потерянные строки, а не косметику —
  /// поэтому она единственная окрашена.
  final bool severe;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              severe ? Icons.error_outline : Icons.info_outline,
              size: 16,
              color: severe ? tokens.danger : tokens.inkMuted,
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              text,
              style: tokens.text.sheetSubtitle.copyWith(
                color: severe ? tokens.danger : tokens.inkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplyBar extends StatelessWidget {
  const _ApplyBar({required this.onCancel, required this.onApply});

  final VoidCallback onCancel;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: ContentColumn(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.screenPadding,
              AppDimens.space12,
              AppDimens.screenPadding,
              AppDimens.space16,
            ),
            child: Row(
              children: [
                AppButton.outlined(
                  label: l10n.actionCancel,
                  expanded: false,
                  width: 110,
                  onPressed: onCancel,
                ),
                const SizedBox(width: AppDimens.space10),
                Expanded(
                  child: AppButton.filled(
                    label: l10n.catalogImportApply,
                    onPressed: onApply,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
