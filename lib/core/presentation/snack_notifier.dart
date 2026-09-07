import 'dart:async';

import 'package:flutter/foundation.dart';

/// Текущее сообщение снека или `null`.
///
/// App-scoped: сообщение «Материал добавлен» переживает возврат с экрана
/// подбора на экран заявки, а `ScaffoldMessenger` уронил бы его вместе
/// со старым `Scaffold`.
class SnackNotifier extends ValueNotifier<String?> {
  SnackNotifier() : super(null);

  static const Duration _visible = Duration(milliseconds: 2400);

  Timer? _timer;

  /// Показывает готовую фразу. Составлять её — работа вызывающего:
  /// он знает и локаль, и что именно произошло.
  void show(String message) {
    _timer?.cancel();
    value = message;
    _timer = Timer(_visible, () => value = null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
