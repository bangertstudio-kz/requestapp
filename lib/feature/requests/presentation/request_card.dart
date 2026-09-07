import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/material_request.dart';
import 'request_status_label.dart';

/// Карточка заявки в списке.
class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.request, required this.onTap});

  final MaterialRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    final count = request.items.length;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(request.name, style: tokens.text.cardTitle)),
              const SizedBox(width: AppDimens.space12),
              AppStatusChip(
                label: requestStatusLabel(l10n, request.status),
                tone: requestStatusTone(request.status),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space10),
          Row(
            children: [
              Text(
                DateFormat(
                  l10n.dateFormatShort,
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(request.createdAt),
                style: tokens.text.meta.copyWith(color: tokens.inkTertiary),
              ),
              const SizedBox(width: AppDimens.space10),
              Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: tokens.inkDisabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppDimens.space10),
              // Число моноширинное, слово — нет: в столбце карточек взгляд
              // цепляется за цифру, а не за склонение рядом с ней.
              Text(
                l10n.requestFolderCount(count),
                style: tokens.text.meta.copyWith(
                  color: tokens.ink,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppDimens.space4),
              Text(
                l10n.requestPositionsWord(count),
                style: tokens.text.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
