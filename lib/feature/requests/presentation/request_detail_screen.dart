import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_item.dart';
import '../domain/entities/request_status.dart';
import 'request_item_card.dart';
import 'request_status_label.dart';

/// Экран заявки: название, позиции и нижняя панель действий.
class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({
    super.key,
    required this.request,
    required this.nameController,
    required this.onNameChanged,
    required this.onAddItem,
    required this.onItemOpened,
    required this.onItemIncrement,
    required this.onItemDecrement,
    required this.onItemRemove,
    required this.folderName,
    required this.onChangeFolder,
    required this.onSave,
    required this.onSend,
    required this.onDelete,
    required this.onBack,
  });

  final MaterialRequest request;

  /// Название правится на месте, без отдельного экрана: это единственное
  /// поле заявки, и открывать ради него форму — лишний переход.
  final TextEditingController nameController;
  final ValueChanged<String> onNameChanged;

  final VoidCallback onAddItem;
  final ValueChanged<RequestItem> onItemOpened;
  final ValueChanged<RequestItem> onItemIncrement;
  final ValueChanged<RequestItem> onItemDecrement;
  final ValueChanged<RequestItem> onItemRemove;

  /// Название папки или `null` — заявка вне папок. Название, а не
  /// идентификатор: экран показывает его, и превращать одно в другое
  /// здесь значило бы тащить сюда список папок целиком.
  final String? folderName;

  final VoidCallback onChangeFolder;

  /// Сохранение и отправка — разные действия, а не одно с ветвлением снаружи:
  /// черновик сохраняют на устройство, сохранённую отправляют.
  final VoidCallback onSave;
  final VoidCallback onSend;

  final VoidCallback onDelete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    final isDraft = request.status == RequestStatus.draft;
    // Подпись считается здесь, а не в параметре виджета: выражение в
    // аргументе прячет строку от анализатора локализации.
    final folderLabel = folderName ?? l10n.folderOutside;

    return Scaffold(
      bottomNavigationBar: _ActionBar(
        mainActionLabel: isDraft ? l10n.actionSave : l10n.actionSend,
        onMainAction: isDraft ? onSave : onSend,
        onAddItem: onAddItem,
        onDelete: onDelete,
      ),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.requestDetailTitle,
                subtitle: request.name,
                onBack: onBack,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          0,
                          AppDimens.screenPadding,
                          AppDimens.space8,
                        ),
                        child: AppLabeledField(
                          label: l10n.requestNameLabel,
                          controller: nameController,
                          onChanged: onNameChanged,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          AppDimens.space10,
                          AppDimens.screenPadding,
                          0,
                        ),
                        child: _FolderRow(
                          name: folderLabel,
                          onTap: onChangeFolder,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.labelPadding,
                          AppDimens.space14,
                          AppDimens.labelPadding,
                          AppDimens.space8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppSectionLabel(
                                l10n.requestMaterialsLabel(
                                  request.items.length,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat(
                                l10n.dateFormatShort,
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(request.createdAt),
                              style: tokens.text.meta.copyWith(
                                color: tokens.inkTertiary,
                              ),
                            ),
                            const SizedBox(width: AppDimens.space8),
                            AppStatusChip(
                              label: requestStatusLabel(l10n, request.status),
                              tone: requestStatusTone(request.status),
                              dense: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      // Панель действий занимает низ экрана; последняя
                      // карточка обязана из-под неё выкручиваться скроллом.
                      padding: const EdgeInsets.fromLTRB(
                        AppDimens.screenPadding,
                        0,
                        AppDimens.screenPadding,
                        AppDimens.space26,
                      ),
                      sliver: request.items.isEmpty
                          ? SliverToBoxAdapter(
                              child: AppEmptyState(
                                message: l10n.requestItemsEmpty,
                              ),
                            )
                          : SliverList.separated(
                              itemCount: request.items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppDimens.space10),
                              itemBuilder: (context, index) {
                                final item = request.items[index];
                                return RequestItemCard(
                                  item: item,
                                  onTap: () => onItemOpened(item),
                                  onIncrement: () => onItemIncrement(item),
                                  onDecrement: () => onItemDecrement(item),
                                  onRemove: () => onItemRemove(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Нижняя панель заявки.
///
/// «Добавить материал» стоит отдельной строкой над остальными: это то, ради
/// чего экран открывают, и делить с ним ширину «Удалить» не должно.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.mainActionLabel,
    required this.onMainAction,
    required this.onAddItem,
    required this.onDelete,
  });

  final String mainActionLabel;
  final VoidCallback onMainAction;
  final VoidCallback onAddItem;
  final VoidCallback onDelete;

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
              AppDimens.space14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.filled(
                  label: l10n.requestAddMaterial,
                  icon: Icons.add,
                  onPressed: onAddItem,
                ),
                const SizedBox(height: AppDimens.space10),
                Row(
                  children: [
                    // Пропорция из макета: главное действие шире отказа,
                    // но не настолько, чтобы «Удалить» стало незаметным.
                    Expanded(
                      flex: 8,
                      child: AppButton.tonal(
                        label: mainActionLabel,
                        onPressed: onMainAction,
                      ),
                    ),
                    const SizedBox(width: AppDimens.space10),
                    Expanded(
                      flex: 5,
                      child: AppButton.dangerOutlined(
                        label: l10n.actionDelete,
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// Папка заявки в шапке экрана: единственная точка входа в перенос.
///
/// Видимая строка, а не долгое нажатие на карточку в списке: функция,
/// о которой нельзя догадаться, глядя на экран, считается отсутствующей.
class _FolderRow extends StatelessWidget {
  const _FolderRow({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Material(
      color: tokens.surfaceMuted,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space12,
            vertical: AppDimens.space10,
          ),
          child: Row(
            children: [
              Text(
                l10n.requestFolderLabel,
                style: tokens.text.meta.copyWith(color: tokens.inkTertiary),
              ),
              const SizedBox(width: AppDimens.space8),
              Expanded(
                child: Text(
                  name,
                  style: tokens.text.rowTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: tokens.inkTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
