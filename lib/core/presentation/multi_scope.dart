import 'package:flutter/widgets.dart';

typedef ScopeWrapper = Widget Function(Widget child);

/// Оборачивает `child` в каждый wrapper — первый в списке снаружи.
///
/// Разворачивает пирамиду скоупов в корне приложения в плоский список:
/// два десятка вложенных провайдеров иначе уезжают на двадцать отступов
/// вправо и перестают читаться.
class MultiScope extends StatelessWidget {
  const MultiScope({super.key, required this.wrappers, required this.child});

  final List<ScopeWrapper> wrappers;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      wrappers.reversed.fold(child, (acc, wrap) => wrap(acc));
}
