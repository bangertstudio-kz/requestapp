/// Исключение, которое уже знает, что сказать читателю.
abstract interface class DescribedException implements Exception {
  /// Готовая фраза на языке читателя или `null` — тогда работает общая
  /// классификация в `failureMessage`.
  String? get message;
}

/// Отказ с готовым объяснением. Бросают репозитории там, где у домена есть
/// своё слово для отказа: «в прайсе нет колонки „Материал“» полезнее, чем
/// «не удалось прочитать файл».
class DescribedFailure implements DescribedException {
  const DescribedFailure(this.message);

  @override
  final String message;

  @override
  String toString() => 'DescribedFailure: $message';
}
