import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../../catalog/presentation/quantity_controller.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_item.dart';
import '../domain/entities/requests_params.dart';
import 'request_detail_notifier.dart';
import 'request_item_screen.dart';
import 'update_request_notifier.dart';

/// Экран позиции заявки.
///
/// Позиция живёт внутри заявки и отдельного репозитория не имеет: экран
/// берёт её из уже загруженной заявки, а правит — сохраняя заявку целиком.
class RequestItemPage extends StatefulWidget {
  const RequestItemPage({
    super.key,
    required this.requestId,
    required this.itemId,
  });

  final String requestId;
  final String itemId;

  @override
  State<RequestItemPage> createState() => _RequestItemPageState();
}

class _RequestItemPageState extends State<RequestItemPage> {
  final _quantity = QuantityController();

  /// Позиция, чьё количество уже стоит в контроллере: перезагрузка заявки
  /// не должна затирать набранное на клавиатуре.
  String? _syncedItemId;

  @override
  void initState() {
    super.initState();
    _scheduleLoad();
  }

  @override
  void didUpdateWidget(covariant RequestItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId == widget.requestId &&
        oldWidget.itemId == widget.itemId) {
      return;
    }
    _syncedItemId = null;
    _scheduleLoad();
  }

  void _scheduleLoad() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<RequestDetailNotifier>(
      context,
    ).request(RequestParams(widget.requestId));
  }

  Future<void> _replace() async {
    await PickItemRoute(
      requestId: widget.requestId,
      replaceItemId: widget.itemId,
    ).push<void>(context);
    if (!mounted) return;
    // Замена возвращает на экран заявки: позиция уже другая, и оставаться
    // на её карточке незачем.
    Navigator.of(context).pop();
  }

  Future<void> _save(MaterialRequest request, RequestItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final snack = NotifierScope.read<SnackNotifier>(context);
    final quantity = _quantity.quantity;
    if (quantity == null) {
      snack.show(l10n.snackQuantityRequired);
      return;
    }

    final notifier = NotifierScope.read<UpdateRequestNotifier>(context);
    await notifier.run(
      UpdateRequestParams(request.replacingItem(item.withQuantity(quantity))),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackQuantityUpdated);
    if (failure == null) Navigator.of(context).pop();
  }

  Future<void> _delete(MaterialRequest request, RequestItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmSheet.show(
      context,
      title: l10n.confirmDeleteItemTitle,
      message: l10n.confirmDeleteItemText,
      confirmLabel: l10n.actionDelete,
    );
    if (!confirmed || !mounted) return;

    final notifier = NotifierScope.read<UpdateRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(UpdateRequestParams(request.removingItem(item.id)));
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackMaterialRemovedFromRequest);
    if (failure == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = NotifierScope.of<RequestDetailNotifier>(context);
    final loaded = notifier.data;
    final request = (loaded != null && loaded.id == widget.requestId)
        ? loaded
        : null;
    final item = request?.items.where((i) => i.id == widget.itemId).firstOrNull;

    if (request == null || item == null) {
      return RequestView<MaterialRequest>(
        // Заявка загружена, а позиции в ней нет — её удалили с другого
        // экрана; для этого экрана это по-прежнему «нечего показать».
        state: notifier.value is RequestSuccess<MaterialRequest>
            ? const RequestLoading<MaterialRequest>(null)
            : notifier.value,
        onRetry: _load,
        placeholderTitle: AppLocalizations.of(context)!.requestItemTitle,
        onBack: () => Navigator.of(context).pop(),
        builder: (context, data) => const SizedBox.shrink(),
      );
    }

    if (_syncedItemId != item.id) {
      _syncedItemId = item.id;
      _quantity.value = '${item.quantity}';
    }

    return RequestItemScreen(
      item: item,
      requestName: request.name,
      quantityController: _quantity,
      onReplaceItem: _replace,
      onSave: () => _save(request, item),
      onDelete: () => _delete(request, item),
      onBack: () => Navigator.of(context).pop(),
    );
  }
}
