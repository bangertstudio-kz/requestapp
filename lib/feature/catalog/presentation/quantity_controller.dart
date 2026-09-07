import 'package:flutter/foundation.dart';
import 'package:request_ui/request_ui.dart';

/// Контроллер поля количества.
///
/// Отдельный контроллер, а не `setState` по нажатию клавиши: поле формы
/// владеет своим значением, и экрану не нужно перестраиваться целиком,
/// чтобы на табло сменилась цифра.
class QuantityController extends ValueNotifier<String> {
  QuantityController([super.value = '']);

  /// Правка существующей позиции начинается с её количества, а не с нуля:
  /// поправить «24» на «26» проще, чем набрать заново.
  QuantityController.fromQuantity(int quantity) : super('$quantity');

  /// Шести разрядов хватает: заявка на миллион штук — это опечатка,
  /// и обрезать её здесь дешевле, чем ловить на отправке.
  static const int maxLength = 6;

  /// Введённое количество или `null`, если введено пусто либо нули.
  /// Ноль — не количество, а незаполненное поле.
  int? get quantity {
    final parsed = int.tryParse(value);
    return (parsed == null || parsed == 0) ? null : parsed;
  }

  void press(AppKeypadKey key) {
    switch (key) {
      case AppKeypadBackspace():
        if (value.isEmpty) return;
        value = value.substring(0, value.length - 1);
      case AppKeypadDigits(:final digits):
        // Ведущий ноль не набирается: «007 штук» — это не то, что имел
        // в виду человек, нажавший «0» первым.
        if (value.isEmpty && int.parse(digits) == 0) return;
        final next = value + digits;
        if (next.length > maxLength) return;
        value = next;
    }
  }
}
