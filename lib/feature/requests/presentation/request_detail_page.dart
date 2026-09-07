import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_item.dart';
import '../domain/entities/requests_params.dart';
import '../domain/entities/send_format.dart';
import 'delete_request_notifier.dart';
import 'request_detail_notifier.dart';
import 'request_detail_screen.dart';
import 'save_request_notifier.dart';
import 'send_request_notifier.dart';
import 'send_request_sheet.dart';
import 'update_request_notifier.dart';

/// Экран заявки.
///
/// [request] может быть `null`: пришли по ссылке — грузим по [requestId]
/// и показываем загрузку; пришли из списка — рисуем сразу. Именно поэтому
/// deep link работает без редиректа через список.
class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({super.key, required this.requestId, this.request});

  final String requestId;
  final MaterialRequest? request;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  final _nameController = TextEditingController();
  final _debouncer = Debouncer();

  /// Заявка, чьё название уже стоит в контроллере. Без этой отметки каждая
  /// перезагрузка затирала бы то, что человек печатает прямо сейчас.
  String? _syncedName;

  @override
  void initState() {
    super.initState();
    final seed = widget.request;
    if (seed != null) _syncName(seed);
    _scheduleLoad();
  }

  @override
  void didUpdateWidget(covariant RequestDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId == widget.requestId) return;
    // go_router переиспользует State, когда переходят с одной заявки
    // на другую: тип виджета тот же, и initState больше не вызовут.
    // Без этого экран остаётся на предыдущей заявке.
    _syncedName = null;
    _scheduleLoad();
  }

  /// Загрузка всегда после кадра: `request` публикует `RequestLoading`
  /// синхронно, а пометить грязным уже построенного предка нельзя.
  void _scheduleLoad() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());

  @override
  void dispose() {
    _nameController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<RequestDetailNotifier>(
      context,
    ).request(RequestParams(widget.requestId));
  }

  void _syncName(MaterialRequest request) {
    if (_syncedName == request.name) return;
    _syncedName = request.name;
    _nameController.text = request.name;
  }

  Future<void> _update(MaterialRequest request) async {
    final notifier = NotifierScope.read<UpdateRequestNotifier>(context);
    await notifier.run(UpdateRequestParams(request));
    if (!mounted) return;
    final failure = notifier.failure;
    if (failure != null) {
      NotifierScope.read<SnackNotifier>(context).show(failure);
      return;
    }
    _load();
  }

  Future<void> _addMaterial() async {
    await PickMaterialRoute(requestId: widget.requestId).push<void>(context);
    _load();
  }

  Future<void> _openItem(RequestItem item) async {
    await RequestItemRoute(
      requestId: widget.requestId,
      itemId: item.id,
    ).push<void>(context);
    _load();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<SaveRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(RequestParams(widget.requestId));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackSavedToDevice);
    _load();
  }

  Future<void> _send() async {
    final format = await SendRequestSheet.show(context);
    if (format == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<SendRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(SendRequestParams(id: widget.requestId, format: format));
    if (!mounted) return;
    snack.show(notifier.failure ?? l10n.snackSent(_formatLabel(l10n, format)));
    _load();
  }

  static String _formatLabel(AppLocalizations l10n, SendFormat format) =>
      switch (format) {
        SendFormat.xml => l10n.sendFormatXml,
        SendFormat.pdf => l10n.sendFormatPdf,
        SendFormat.both => l10n.sendFormatBoth,
      };

  Future<void> _delete(MaterialRequest request) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteRequestTitle,
      message: l10n.confirmDeleteRequestText(
        request.name,
        request.items.length,
      ),
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<DeleteRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(RequestParams(widget.requestId));
    if (!mounted) return;
    final failure = notifier.failure;
    if (failure != null) {
      snack.show(failure);
      return;
    }
    snack.show(l10n.snackRequestDeleted);
    // Экран удалённой заявки закрывается сам: оставлять его открытым значит
    // показывать документ, которого больше нет.
    Navigator.of(context).pop();
  }

  Future<void> _removeItem(MaterialRequest request, RequestItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final snack = NotifierScope.read<SnackNotifier>(context);
    await _update(request.removingItem(item.id));
    if (!mounted) return;
    snack.show(l10n.snackMaterialRemovedFromRequest);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.of<RequestDetailNotifier>(context);

    // Данные нотифаера годятся, только если это та самая заявка: нотифаер
    // app-scoped, и при переходе между заявками он какое-то время держит
    // предыдущую.
    final loaded = notifier.data;
    final request = (loaded != null && loaded.id == widget.requestId)
        ? loaded
        : widget.request;

    if (request == null) {
      return RequestView<MaterialRequest>(
        // Успех с чужой заявкой для этого экрана — всё ещё загрузка:
        // отдать его в builder значит нарисовать пустой белый экран.
        state: notifier.value is RequestSuccess<MaterialRequest>
            ? const RequestLoading<MaterialRequest>(null)
            : notifier.value,
        onRetry: _load,
        placeholderTitle: l10n.requestDetailTitle,
        onBack: () => Navigator.of(context).pop(),
        builder: (context, data) => const SizedBox.shrink(),
      );
    }

    _syncName(request);

    return RequestDetailScreen(
      request: request,
      nameController: _nameController,
      onNameChanged: (value) =>
          _debouncer.run(() => _update(request.withName(value))),
      onAddMaterial: _addMaterial,
      onItemOpened: _openItem,
      onItemIncrement: (item) =>
          _update(request.replacingItem(item.withQuantity(item.quantity + 1))),
      onItemDecrement: (item) =>
          _update(request.replacingItem(item.withQuantity(item.quantity - 1))),
      onItemRemove: (item) => _removeItem(request, item),
      onSave: _save,
      onSend: _send,
      onDelete: () => _delete(request),
      onBack: () => Navigator.of(context).pop(),
    );
  }
}
