import 'package:flutter/widgets.dart';

/// Один провайдер на любой `Listenable`.
///
/// Каждый тип-аргумент — отдельный inherited-тип в рантайме, поэтому скоупы
/// разных нотифаеров не сталкиваются, и заводить свой `InheritedNotifier`
/// под каждый нотифаер не нужно.
class NotifierScope<N extends Listenable> extends InheritedNotifier<N> {
  const NotifierScope({super.key, required N controller, required super.child})
    : super(notifier: controller);

  /// Подписывается — вызывающий перестраивается. Для `build`.
  static N of<N extends Listenable>(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<NotifierScope<N>>();
    assert(scope != null, 'NotifierScope<$N> не найден выше по дереву.');
    return scope!.notifier!;
  }

  /// Не подписывается. Для колбэков и `initState`.
  static N read<N extends Listenable>(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<NotifierScope<N>>();
    assert(scope != null, 'NotifierScope<$N> не найден выше по дереву.');
    return scope!.notifier!;
  }
}
