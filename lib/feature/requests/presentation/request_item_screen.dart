import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../../catalog/presentation/material_unit_label.dart';
import '../../catalog/presentation/quantity_controller.dart';
import '../domain/entities/request_item.dart';

/// Экран позиции заявки: чем является материал и сколько его нужно.
///
/// Отдельный экран, а не шторка: сюда попадают из уже собранной заявки,
/// и здесь доступна замена материала — действие, уводящее на другой экран.
/// Шторка, из которой открывается другая шторка, теряет контекст возврата.
class RequestItemScreen extends StatelessWidget {
  const RequestItemScreen({
    super.key,
    required this.item,
    required this.requestName,
    required this.quantityController,
    required this.onReplaceMaterial,
    required this.onSave,
    required this.onDelete,
    required this.onBack,
  });

  final RequestItem item;
  final String requestName;
  final QuantityController quantityController;
  final VoidCallback onReplaceMaterial;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Scaffold(
      bottomNavigationBar: _ActionBar(onSave: onSave, onDelete: onDelete),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: l10n.requestItemTitle,
                subtitle: requestName,
                onBack: onBack,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    AppDimens.space6,
                    AppDimens.screenPadding,
                    AppDimens.space26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppDimens.space16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.name, style: tokens.text.materialTitle),
                            const SizedBox(height: 5),
                            Text(
                              l10n.materialPath(
                                item.categoryName,
                                item.subcategoryName,
                              ),
                              style: tokens.text.bodySmall.copyWith(
                                color: tokens.inkMuted,
                              ),
                            ),
                            const SizedBox(height: AppDimens.space14),
                            // Кнопка по ширине надписи: растянутая на всю
                            // карточку, она читалась бы как главное действие
                            // экрана, а главное здесь — количество.
                            Align(
                              alignment: Alignment.centerLeft,
                              child: AppButton.outlinedAccent(
                                label: l10n.requestItemReplaceMaterial,
                                onPressed: onReplaceMaterial,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      ValueListenableBuilder<String>(
                        valueListenable: quantityController,
                        builder: (context, value, _) => AppQuantityDisplay(
                          label: l10n.quantityLabel,
                          hint: l10n.quantityHint,
                          value: value.isEmpty ? l10n.quantityEmpty : value,
                          unit: materialUnitLabel(l10n, item.unit),
                          empty: value.isEmpty,
                        ),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      AppNumericKeypad(
                        onKey: quantityController.press,
                        backspaceSemanticLabel: l10n.actionBackspace,
                      ),
                    ],
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

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onSave, required this.onDelete});

  final VoidCallback onSave;
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
              AppDimens.space16,
            ),
            child: Row(
              children: [
                // Ширина фиксированная, а не доля: «Удалить» не должно расти
                // вместе с длиной слова «Сохранить» в другой локали.
                AppButton.dangerOutlined(
                  label: l10n.actionDelete,
                  size: AppButtonSize.large,
                  expanded: false,
                  width: 120,
                  onPressed: onDelete,
                ),
                const SizedBox(width: AppDimens.space10),
                Expanded(
                  child: AppButton.filled(
                    label: l10n.actionSave,
                    onPressed: onSave,
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
