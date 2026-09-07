import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_material.dart';
import 'material_unit_label.dart';
import 'quantity_controller.dart';

/// Шторка ввода количества для выбранного материала.
///
/// Не модальная: список материалов под ней остаётся виден и прокручивается.
/// Модальная шторка здесь заставляла бы закрывать её, чтобы убедиться,
/// что выбран нужный диаметр, — и открывать заново.
class QuantitySheet extends StatelessWidget {
  const QuantitySheet({
    super.key,
    required this.material,
    required this.controller,
    required this.onAdd,
    required this.onClose,
  });

  final CatalogMaterial material;
  final QuantityController controller;

  /// Вызывается только с непустым количеством: пустое поле гасит кнопку,
  /// а не показывает ошибку после нажатия.
  final ValueChanged<int> onAdd;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(material.name, style: tokens.text.sheetTitle),
                    const SizedBox(height: 3),
                    Text(
                      l10n.materialPath(
                        material.categoryName,
                        material.subcategoryName,
                      ),
                      style: tokens.text.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              AppIconButton(
                icon: Icons.close,
                size: AppDimens.buttonSmall,
                iconSize: 18,
                color: tokens.inkTertiary,
                semanticLabel: l10n.actionClose,
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space12),
          ValueListenableBuilder<String>(
            valueListenable: controller,
            builder: (context, value, _) {
              final quantity = controller.quantity;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppQuantityDisplay(
                    label: l10n.quantityLabel,
                    hint: l10n.quantityHint,
                    value: value.isEmpty ? l10n.quantityEmpty : value,
                    unit: materialUnitLabel(l10n, material.unit),
                    empty: value.isEmpty,
                    onSurface: false,
                  ),
                  const SizedBox(height: AppDimens.space12),
                  AppNumericKeypad(
                    compact: true,
                    onKey: controller.press,
                    backspaceSemanticLabel: l10n.actionBackspace,
                  ),
                  const SizedBox(height: AppDimens.space12),
                  AppButton.filled(
                    label: l10n.pickAddToRequest,
                    onPressed: quantity == null ? null : () => onAdd(quantity),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
