import 'dart:async';

import 'package:flutter/foundation.dart';

/// Откладывает вызов, пока его перестанут дёргать.
///
/// Поиск по 326 материалам перезапускается на каждую букву; без задержки
/// «труба» — это пять запросов, из которых нужен один, и четыре гонки
/// за то, чей ответ ляжет последним.
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 280)});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
