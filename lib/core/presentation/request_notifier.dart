import 'package:flutter/foundation.dart';

import '../domain/entities/params.dart';
import 'app_text.dart';
import 'failure_message.dart';

/// Состояние одного запроса.
sealed class RequestState<T> {
  const RequestState();
}

class RequestInitial<T> extends RequestState<T> {
  const RequestInitial();
}

/// Загрузка, несущая предыдущие данные.
///
/// Экран обязан их рисовать: обновление, подменяющее нарисованный ответ
/// спиннером, — это мигание, которое не сообщает читателю ничего нового.
class RequestLoading<T> extends RequestState<T> {
  const RequestLoading(this.data);

  final T? data;
}

class RequestSuccess<T> extends RequestState<T> {
  const RequestSuccess(this.data);

  final T data;
}

class RequestError<T> extends RequestState<T> {
  const RequestError(this.message, [this.exception]);

  /// Готовая фраза: превращение исключения в текст произошло здесь, в слое,
  /// который знает язык, а не на экране.
  final String message;
  final Object? exception;
}

/// Один запрос — один нотифаер.
///
/// Нотифаер не хранит своих аргументов: каждый запуск получает, что тянуть.
/// Иначе `refresh()` начинает зависеть от того, кто и когда последним
/// вызвал `request`, и это перестаёт быть видно из кода экрана.
abstract class RequestNotifier<T, P extends Params?>
    extends ValueNotifier<RequestState<T>> {
  RequestNotifier() : super(RequestInitial<T>());

  @protected
  Future<T> fetch(P params);

  Future<void> request(P params) async {
    final current = value;
    // Повторный запуск на лету — no-op: два параллельных запроса пишут
    // в одно поле, и какой из них ляжет вторым, никто не контролирует.
    if (current is RequestLoading) return;

    value = RequestLoading<T>(
      current is RequestSuccess<T> ? current.data : null,
    );
    try {
      value = RequestSuccess<T>(await fetch(params));
    } catch (error) {
      value = RequestError<T>(failureMessage(AppText.current, error), error);
    }
  }

  /// Текущие данные, если они есть, — включая те, что несёт загрузка.
  T? get data => switch (value) {
    RequestSuccess<T>(:final data) => data,
    RequestLoading<T>(:final data) => data,
    _ => null,
  };
}

/// Запуск операции из колбэка экрана.
///
/// Экран почти всегда хочет одно и то же: выполнить и узнать, получилось ли.
/// Подписываться на нотифаер мутации ради этого — лишний слушатель, который
/// потом забудут снять.
extension RequestNotifierRun<T, P extends Params?> on RequestNotifier<T, P> {
  /// Выполняет запрос и возвращает данные или `null`, если он не удался.
  Future<T?> run(P params) async {
    await request(params);
    return switch (value) {
      RequestSuccess<T>(:final data) => data,
      _ => null,
    };
  }

  /// Фраза последней ошибки или `null`.
  String? get failure => switch (value) {
    RequestError<T>(:final message) => message,
    _ => null,
  };
}
