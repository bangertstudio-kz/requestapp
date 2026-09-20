import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/request_document.dart';
import '../domain/entities/requests_params.dart';
import '../domain/entities/send_format.dart';
import 'prepare_documents_notifier.dart';
import 'request_detail_notifier.dart';
import 'request_preview_screen.dart';
import 'send_request_notifier.dart';

/// Экран предпросмотра файлов: собрать, показать, отдать системе.
class RequestPreviewPage extends StatefulWidget {
  const RequestPreviewPage({
    super.key,
    required this.requestId,
    required this.format,
  });

  final String requestId;
  final SendFormat format;

  @override
  State<RequestPreviewPage> createState() => _RequestPreviewPageState();
}

class _RequestPreviewPageState extends State<RequestPreviewPage> {
  @override
  void initState() {
    super.initState();
    // Файлы собираются при каждом входе, а не кэшируются: заявку правят,
    // и собранный час назад документ описывает не её.
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<PrepareDocumentsNotifier>(
      context,
    ).request(SendRequestParams(id: widget.requestId, format: widget.format));
  }

  Future<void> _share(List<RequestDocument> documents) async {
    final l10n = AppLocalizations.of(context)!;
    final snack = NotifierScope.read<SnackNotifier>(context);
    final notifier = NotifierScope.read<SendRequestNotifier>(context);

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [
          for (final document in documents)
            XFile(document.path, name: document.name),
        ],
        // Тема письма: название заявки, а если экран открыли по ссылке
        // и его нет — имя файла. Пустая тема хуже транслитерации.
        subject: _requestName ?? documents.first.name,
      ),
    );
    if (!mounted) return;

    // Лист закрыли, ничего не выбрав. Отметить отправку здесь значило бы
    // показать в списке «Отправлена» заявку, которую никто не получил, —
    // и узнают об этом от прораба, а не от приложения.
    if (result.status == ShareResultStatus.dismissed) return;

    await notifier.run(
      SendRequestParams(id: widget.requestId, format: widget.format),
    );
    if (!mounted) return;

    final failure = notifier.failure;
    if (failure != null) {
      snack.show(failure);
      return;
    }
    snack.show(l10n.snackSent(_formatLabel(l10n, widget.format)));
    Navigator.of(context).pop();
  }

  /// Название открытой заявки.
  ///
  /// Из нотифаера детали, а не из имени файла: имя транслитерировано, и
  /// «Склад №3, расходники» показалось бы человеку как «sklad-3-rashodniki».
  /// Сверяем идентификатор — нотифаер app-scoped и какое-то время держит
  /// предыдущую заявку.
  String? get _requestName {
    final loaded = NotifierScope.read<RequestDetailNotifier>(context).data;
    return loaded?.id == widget.requestId ? loaded?.name : null;
  }

  static String _formatLabel(AppLocalizations l10n, SendFormat format) =>
      switch (format) {
        SendFormat.xlsx => l10n.sendFormatExcel,
        SendFormat.pdf => l10n.sendFormatPdf,
        SendFormat.both => l10n.sendFormatBoth,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.of<PrepareDocumentsNotifier>(context);

    return RequestView<List<RequestDocument>>(
      state: notifier.value,
      onRetry: _load,
      placeholderTitle: l10n.previewTitle,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, documents) => RequestPreviewScreen(
        requestName: _requestName,
        documents: documents,
        onShare: () => _share(documents),
        onBack: () => Navigator.of(context).pop(),
      ),
    );
  }
}
