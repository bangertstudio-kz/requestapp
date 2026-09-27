import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Отдаёт файл браузеру как загрузку.
Future<void> saveToDevice(String name, Uint8List bytes) async {
  final blob = web.Blob([bytes.toJS].toJS);
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = name;
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  // Ссылку отзываем не сразу: браузер начинает загрузку асинхронно, и
  // отозванный до этого адрес превращается в «файл не найден».
  await Future<void>.delayed(const Duration(seconds: 1));
  web.URL.revokeObjectURL(url);
}
