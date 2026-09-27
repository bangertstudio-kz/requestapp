import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_import.dart';
import '../domain/entities/catalog_params.dart';
import 'apply_import_notifier.dart';
import 'catalog_flatten.dart';
import 'catalog_import_screen.dart';
import 'catalog_notifier.dart';
import 'category_pick_sheet.dart';
import 'item_path_label.dart';
import 'parse_import_notifier.dart';

/// Импорт материалов из файла Excel.
class CatalogImportPage extends StatefulWidget {
  const CatalogImportPage({super.key, this.categoryId});

  /// Откуда пришли. Не `null` — приёмник предложен сразу: импорт открыли
  /// из категории, и спрашивать про неё второй раз незачем.
  final String? categoryId;

  @override
  State<CatalogImportPage> createState() => _CatalogImportPageState();
}

class _CatalogImportPageState extends State<CatalogImportPage> {
  late String? _categoryId = widget.categoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) NotifierScope.read<CatalogNotifier>(context).request(null);
    });
  }

  Future<void> _pick() async {
    // Только .xlsx: разбор читает книгу Excel, и выбранный .csv упал бы
    // уже после диалога — отсекать формат до него дешевле.
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['xlsx'],
    );
    final file = picked.singleOrNull;
    if (file == null) return;
    // Содержимое, а не путь: в браузере у выбранного файла пути нет,
    // а прайс в пару сотен строк в памяти ничего не стоит.
    final bytes = await file.readAsBytes();
    if (!mounted) return;

    await NotifierScope.read<ParseImportNotifier>(context).run(
      ParseImportParams(
        bytes: bytes,
        fileName: file.name,
        categoryId: _categoryId,
      ),
    );
  }

  Future<void> _pickTarget(List<CatalogCategory> categories) async {
    final picked = await CategoryPickSheet.show(
      context,
      options: [
        for (final category in flattenCategories(categories))
          (category: category, path: _pathOf(categories, category)),
      ],
      selectedId: _categoryId,
    );
    if (picked == null || !mounted) return;
    setState(() => _categoryId = picked);
    // Отчёт посчитан для прежнего приёмника: в другой категории те же
    // строки дадут другие цифры, и показывать старые — врать.
    NotifierScope.read<ParseImportNotifier>(context).reset();
  }

  void _pickRoot() {
    setState(() => _categoryId = null);
    NotifierScope.read<ParseImportNotifier>(context).reset();
  }

  Future<void> _copyPrompt() async {
    final l10n = AppLocalizations.of(context)!;
    final snack = NotifierScope.read<SnackNotifier>(context);
    await Clipboard.setData(ClipboardData(text: l10n.catalogImportPrompt));
    if (!mounted) return;
    snack.show(l10n.catalogImportPromptCopied);
  }

  Future<void> _apply(CatalogImport import) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmImportTitle,
      message: l10n.confirmImportText(
        import.summary.itemsAdded + import.summary.itemsUpdated,
      ),
      confirmLabel: l10n.confirmImportAction,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<ApplyImportNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final written = await notifier.run(ApplyImportParams(import));
    if (!mounted) return;

    final failure = notifier.failure;
    if (failure != null) {
      snack.show(failure);
      return;
    }
    snack.show(l10n.snackCatalogImported(written ?? 0));
    // Справочник изменился — экран, с которого пришли, должен это увидеть.
    NotifierScope.read<CatalogNotifier>(context).request(null);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parse = NotifierScope.of<ParseImportNotifier>(context);
    final categories =
        NotifierScope.of<CatalogNotifier>(context).data ??
        const <CatalogCategory>[];

    final target = _categoryId == null
        ? null
        : findCategory(categories, _categoryId!);
    final import = parse.data;

    return CatalogImportScreen(
      targetLabel: target == null
          ? l10n.catalogImportTargetRoot
          : itemPathLabel(l10n, _pathOf(categories, target)),
      targetIsRoot: _categoryId == null,
      summary: import?.summary,
      parsing: parse.value is RequestLoading<CatalogImport>,
      errorMessage: parse.failure,
      onPickTarget: () => _pickTarget(categories),
      onPickRoot: _pickRoot,
      onCopyPrompt: _copyPrompt,
      onPickFile: _pick,
      onApply: () {
        if (import != null) _apply(import);
      },
      onBack: () => Navigator.of(context).pop(),
    );
  }

  static List<String> _pathOf(
    List<CatalogCategory> categories,
    CatalogCategory target,
  ) {
    final byId = {
      for (final item in flattenCategories(categories)) item.id: item,
    };
    final names = <String>[];
    final seen = <String>{};
    CatalogCategory? cursor = target;
    while (cursor != null && seen.add(cursor.id)) {
      names.insert(0, cursor.name);
      final parentId = cursor.parentId;
      cursor = parentId == null ? null : byId[parentId];
    }
    return names;
  }
}
