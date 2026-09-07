import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/request_status.dart';

/// Подпись статуса заявки.
String requestStatusLabel(AppLocalizations l10n, RequestStatus status) =>
    switch (status) {
      RequestStatus.draft => l10n.statusDraft,
      RequestStatus.saved => l10n.statusSaved,
      RequestStatus.sent => l10n.statusSent,
    };

/// Тон чипа для статуса.
///
/// Отображение живёт здесь, а не в дизайн-системе: пакет не знает слова
/// «черновик», он знает «нейтральный». Здесь — знает.
AppStatusTone requestStatusTone(RequestStatus status) => switch (status) {
  RequestStatus.draft => AppStatusTone.neutral,
  RequestStatus.saved => AppStatusTone.positive,
  RequestStatus.sent => AppStatusTone.info,
};
