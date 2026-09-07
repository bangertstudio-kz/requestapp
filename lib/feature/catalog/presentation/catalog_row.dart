import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';

/// Строка справочника: название, пояснение и два действия.
///
/// Правка и удаление стоят прямо в строке, а не за долгим нажатием: справочник
/// правит тот же человек, что и заявки, и делает это по одной записи —
/// прятать действия ради чистоты списка значит прятать саму функцию.
class CatalogRow extends StatelessWidget {
  const CatalogRow({
    super.key,
    required this.name,
    required this.meta,
    required this.onOpen,
    required this.onEdit,
    required this.onRemove,
  });

  final String name;
  final String meta;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      borderRadius: AppDimens.radiusControl,
      minHeight: 60,
      padding: const EdgeInsets.fromLTRB(
        15,
        AppDimens.space12,
        AppDimens.space8,
        AppDimens.space12,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name, style: tokens.text.rowTitle),
                    const SizedBox(height: AppDimens.space2),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.space6),
          AppButton.text(label: l10n.actionEditShort, onPressed: onEdit),
          AppIconButton(
            icon: Icons.close,
            size: AppDimens.buttonSmall,
            iconSize: 17,
            color: tokens.danger,
            semanticLabel: l10n.actionRemove,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
