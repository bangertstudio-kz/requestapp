import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../../catalog/presentation/material_unit_label.dart';
import '../domain/entities/request_item.dart';

/// Позиция заявки: материал, путь, количество и три действия под чертой.
///
/// «Плюс/минус» и «Удалить» вынесены в карточку, а не в свайп: свайп на
/// экране, где список уже скроллится, обнаруживается случайно и срабатывает
/// тоже случайно.
class RequestItemCard extends StatelessWidget {
  const RequestItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final RequestItem item;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space14,
        AppDimens.space14,
        AppDimens.space14,
        AppDimens.space10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.name, style: tokens.text.itemTitle),
                      const SizedBox(height: 3),
                      Text(
                        l10n.materialPath(
                          item.categoryName,
                          item.subcategoryName,
                        ),
                        style: tokens.text.caption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.materialQuantity(item.quantity),
                      style: tokens.text.quantityValue,
                    ),
                    const SizedBox(width: AppDimens.space4),
                    Text(
                      materialUnitLabel(l10n, item.unit),
                      style: tokens.text.quantityValueUnit,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.space10),
          Container(
            height: 1,
            color: tokens.divider,
            margin: const EdgeInsets.only(bottom: AppDimens.space8),
          ),
          Row(
            children: [
              AppStepperButton(
                icon: Icons.remove,
                semanticLabel: l10n.requestDecreaseQuantity,
                // Ниже единицы кнопка гаснет: ноль в заявке — это не
                // количество, а забытая позиция.
                onPressed: item.quantity > 1 ? onDecrement : null,
              ),
              const SizedBox(width: AppDimens.space8),
              AppStepperButton(
                icon: Icons.add,
                semanticLabel: l10n.requestIncreaseQuantity,
                onPressed: onIncrement,
              ),
              const Spacer(),
              AppButton.dangerText(
                label: l10n.actionDelete,
                onPressed: onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
