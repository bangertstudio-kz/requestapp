import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Кладёт файл в каталог документов приложения.
Future<void> saveToDevice(String name, Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  await File('${directory.path}/$name').writeAsBytes(bytes);
}
