import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../data/request_xlsx.dart';
import '../domain/entities/request_document.dart';

/// Экран предпросмотра файлов заявки перед отправкой.
///
/// Показывает то, что уйдёт, — а не то, из чего оно собрано: книгу Excel
/// таблицей, PDF страницами. Проверять документ после отправки поздно.
class RequestPreviewScreen extends StatefulWidget {
  const RequestPreviewScreen({
    super.key,
    required this.requestName,
    required this.documents,
    required this.onShare,
    required this.onBack,
  });

  /// Название заявки в подзаголовке. `null` — экран открыли по ссылке,
  /// и заявка ещё не загружена: пусто честнее, чем имя файла, в котором
  /// «Склад №3» выглядит как «sklad-3».
  final String? requestName;

  /// Один файл или два — зависит от формата, выбранного в шторке.
  final List<RequestDocument> documents;

  final VoidCallback onShare;
  final VoidCallback onBack;

  @override
  State<RequestPreviewScreen> createState() => _RequestPreviewScreenState();
}

class _RequestPreviewScreenState extends State<RequestPreviewScreen> {
  /// Первым открывается PDF: его смотрят, таблицу листают редко.
  late int _selected = widget.documents.indexWhere(
    (document) => document.format == DocumentFormat.pdf,
  );

  @override
  void initState() {
    super.initState();
    if (_selected < 0) _selected = 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    final document = widget.documents[_selected];

    return Scaffold(
      bottomNavigationBar: _SendBar(onShare: widget.onShare),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.previewTitle,
                subtitle: widget.requestName,
                onBack: widget.onBack,
                backSemanticLabel: l10n.actionBack,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  0,
                  AppDimens.screenPadding,
                  AppDimens.space10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0;
                        index < widget.documents.length;
                        index++)
                      _DocumentRow(
                        document: widget.documents[index],
                        selected: index == _selected,
                        // Один файл — переключать нечего, и строка
                        // перестаёт быть кнопкой.
                        onTap: widget.documents.length == 1
                            ? null
                            : () => setState(() => _selected = index),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    0,
                    AppDimens.screenPadding,
                    AppDimens.space10,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                    border: Border.all(color: tokens.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: switch (document.format) {
                    DocumentFormat.xlsx => _SheetPreview(bytes: document.bytes),
                    DocumentFormat.pdf => _PdfPreview(bytes: document.bytes),
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

/// Строка файла: имя, размер и — если файлов два — выбор.
class _DocumentRow extends StatelessWidget {
  const _DocumentRow({
    required this.document,
    required this.selected,
    required this.onTap,
  });

  final RequestDocument document;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    final size = NumberFormat(
      '#,##0.0',
      Localizations.localeOf(context).toLanguageTag(),
    ).format(document.sizeBytes / 1024);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Material(
        color: selected ? tokens.primarySelected : tokens.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: selected ? tokens.borderSelectedSoft : tokens.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    document.name,
                    style: tokens.text.rowTitle.copyWith(
                      color: selected ? tokens.primary : tokens.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppDimens.space8),
                Text(
                  l10n.previewFileSize(size),
                  style: tokens.text.meta.copyWith(
                    color: selected ? tokens.primary : tokens.inkTertiary,
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

/// Лист книги Excel таблицей.
///
/// Читаем готовый файл, а не собираем таблицу из заявки заново: экран обязан
/// показывать то, что уйдёт. Вторая сборка тех же данных однажды разойдётся
/// с первой, и разойдётся молча.
class _SheetPreview extends StatefulWidget {
  const _SheetPreview({required this.bytes});

  final Uint8List bytes;

  @override
  State<_SheetPreview> createState() => _SheetPreviewState();
}

class _SheetPreviewState extends State<_SheetPreview> {
  late final Future<List<List<String>>> _rows = _read();

  Future<List<List<String>>> _read() async => readXlsxRows(widget.bytes);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return FutureBuilder<List<List<String>>>(
      future: _rows,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _PreviewMessage(text: l10n.previewSheetFailed);
        }
        final rows = snapshot.data;
        if (rows == null) return const _PreviewLoading();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: TableBorder.all(color: tokens.border),
              children: [
                for (var index = 0; index < rows.length; index++)
                  TableRow(
                    // Первая строка — шапка листа: в книге она тоже первая,
                    // и выделять её здесь значит показывать файл как есть.
                    decoration: index == 0
                        ? BoxDecoration(color: tokens.surfaceNeutral)
                        : null,
                    children: [
                      for (final cell in rows[index])
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.space8,
                            vertical: AppDimens.space4,
                          ),
                          child: Text(
                            cell,
                            style: index == 0
                                ? tokens.text.meta
                                : tokens.text.caption,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// PDF страницами-картинками.
///
/// Не встроенный просмотрщик: у него своя панель и своя кнопка «поделиться»
/// рядом с нашей, а проверить документ перед отправкой хватает картинок.
class _PdfPreview extends StatefulWidget {
  const _PdfPreview({required this.bytes});

  final Uint8List bytes;

  @override
  State<_PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<_PdfPreview> {
  late final Future<List<Uint8List>> _pages = _rasterize();

  Future<List<Uint8List>> _rasterize() async {
    final pages = <Uint8List>[];
    await for (final page in Printing.raster(widget.bytes, dpi: 96)) {
      pages.add(await page.toPng());
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<List<Uint8List>>(
      future: _pages,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _PreviewMessage(text: l10n.previewPdfFailed);
        }
        final pages = snapshot.data;
        if (pages == null) return const _PreviewLoading();

        return ListView.separated(
          padding: const EdgeInsets.all(AppDimens.space12),
          itemCount: pages.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppDimens.space10),
          itemBuilder: (context, index) => Image.memory(pages[index]),
        );
      },
    );
  }
}

class _PreviewLoading extends StatelessWidget {
  const _PreviewLoading();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: tokens.text.emptyState.copyWith(color: tokens.inkMuted),
        ),
      ),
    );
  }
}

class _SendBar extends StatelessWidget {
  const _SendBar({required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Container(
      color: tokens.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.screenPadding,
            AppDimens.space10,
            AppDimens.screenPadding,
            AppDimens.space10,
          ),
          child: AppButton.filled(label: l10n.actionSend, onPressed: onShare),
        ),
      ),
    );
  }
}
