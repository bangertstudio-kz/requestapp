import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../generated/app_localizations.dart';
import '../domain/described_exception.dart';

/// Превращает исключение в фразу для читателя.
///
/// Вызывается только из нотифаеров, никогда из экрана — поэтому принимает
/// `l10n`, а не `BuildContext`. Никаких «фолбэков на вызывающего»: фраза,
/// угадывающая, что делал экран, — это догадка, выданная за объяснение.
///
/// Ветки `DioException` здесь нет: приложение локальное, сети у него пока не
/// существует. Она добавляется вместе с первым сетевым репозиторием, первым
/// пунктом после [DescribedException].
String failureMessage(AppLocalizations l10n, Object? error) {
  if (error is DescribedException) {
    final message = error.message;
    if (message != null && message.isNotEmpty) return message;
  }

  if (error is TimeoutException) return l10n.errorTimeout;

  // Порядок важен: все они — IOException, и общий кейс съест частные,
  // если поставить его выше.
  if (error is TlsException) return l10n.errorCertificate;
  if (error is SocketException) return l10n.errorConnection;
  if (error is HttpException) return l10n.errorConnection;
  if (error is WebSocketException) return l10n.errorConnection;
  if (error is FileSystemException) return l10n.errorStorage;
  if (error is IOException) return l10n.errorStorage;

  if (error is FormatException) return l10n.errorFormat;
  if (error is PlatformException) return l10n.errorPlatform;

  return l10n.errorUnknown;
}
