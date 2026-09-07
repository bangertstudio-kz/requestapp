import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_import_summary.dart';
import '../domain/entities/catalog_params.dart';
import 'apply_price_list_notifier.dart';
import 'catalog_import_screen.dart';
import 'catalog_notifier.dart';
import 'parse_price_list_notifier.dart';

/// Обновление справочника из файла прайса.
class CatalogImportPage extends StatefulWidget {
  const CatalogImportPage({super.key});

  @override
  State<CatalogImportPage> createState() => _CatalogImportPageState();
}

class _CatalogImportPageState extends State<CatalogImportPage> {
  /// Имя файла, которое возвращает системный выбор.
  ///
  /// Настоящий выбор файла придёт вместе с `file_picker`; пока моки
  /// подставляют имя прайса заказчика — разбирается всё равно он.
  static const String _pickedFile = 'Прайс сантехника-SergeyM 2.xlsx';

  Future<void> _pick() async {
    final notifier = NotifierScope.read<ParsePriceListNotifier>(context);
    await notifier.run(const ParsePriceListParams(_pickedFile));
  }

  Future<void> _apply(CatalogImportSummary summary) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmImportTitle,
      message: l10n.confirmImportText(summary.materials),
      confirmLabel: l10n.confirmImportAction,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<ApplyPriceListNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final count = await notifier.run(ApplyPriceListParams(summary));
    if (!mounted) return;

    final failure = notifier.failure;
    if (failure != null) {
      snack.show(failure);
      return;
    }
    // Справочник в памяти уже другой — перечитываем его до того, как
    // экран закроется, иначе список позади останется старым.
    NotifierScope.read<CatalogNotifier>(context).request(null);
    snack.show(l10n.snackCatalogImported(count ?? summary.materials));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final parse = NotifierScope.of<ParsePriceListNotifier>(context);
    final state = parse.value;

    return CatalogImportScreen(
      summary: switch (state) {
        RequestSuccess<CatalogImportSummary>(:final data) => data,
        _ => null,
      },
      parsing: state is RequestLoading<CatalogImportSummary>,
      errorMessage: switch (state) {
        RequestError<CatalogImportSummary>(:final message) => message,
        _ => null,
      },
      onPickFile: _pick,
      onApply: () {
        final summary = parse.data;
        if (summary != null) _apply(summary);
      },
      onBack: () => Navigator.of(context).pop(),
    );
  }
}
