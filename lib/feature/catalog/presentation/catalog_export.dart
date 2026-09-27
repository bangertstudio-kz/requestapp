import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../domain/entities/catalog_params.dart';
import 'export_catalog_notifier.dart';

/// Собирает Excel справочника или ветки и открывает системный лист
/// «Поделиться»: сохранить в файлы, отправить в мессенджер или почтой —
/// решает человек, а не приложение.
Future<void> shareCatalogExport(
  BuildContext context, {
  String? categoryId,
  required String subject,
}) async {
  final notifier = NotifierScope.read<ExportCatalogNotifier>(context);
  final snack = NotifierScope.read<SnackNotifier>(context);

  final path = await notifier.run(ExportCatalogParams(categoryId: categoryId));
  if (path == null) {
    final failure = notifier.failure;
    if (failure != null) snack.show(failure);
    return;
  }
  await SharePlus.instance.share(
    ShareParams(files: [XFile(path)], subject: subject),
  );
}
