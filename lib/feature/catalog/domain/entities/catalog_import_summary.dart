/// Что даст импорт прайса, если его подтвердить.
///
/// Считается при разборе файла, до того как справочник тронут. Пользователь
/// должен увидеть цифры и предупреждения раньше, чем нажмёт «Заменить»:
/// импорт затирает справочник целиком, и «сначала загрузим, потом посмотрим»
/// здесь означает потерю ручных правок без предупреждения.
class CatalogImportSummary {
  const CatalogImportSummary({
    required this.fileName,
    required this.categories,
    required this.subcategories,
    required this.materials,
    required this.duplicatesRemoved,
    required this.rowsTrimmed,
    required this.rowsSkipped,
    required this.unknownUnits,
  });

  final String fileName;

  final int categories;
  final int subcategories;
  final int materials;

  /// Полностью совпадающие строки прайса. В исходном файле их шесть —
  /// это свойство источника, а не ошибка разбора.
  final int duplicatesRemoved;

  /// Строки, где потребовался trim и сжатие пробелов. Показываем числом,
  /// а не списком: важно, что правки были, а не какие именно.
  final int rowsTrimmed;

  /// Строки без названия или без категории — загружать нечего.
  final int rowsSkipped;

  /// Единицы измерения из файла, которых нет среди трёх допустимых.
  /// Список, а не счётчик: чтобы исправить прайс, нужно знать, что писать.
  final List<String> unknownUnits;

  /// Есть ли что показать в блоке предупреждений.
  bool get hasWarnings =>
      duplicatesRemoved > 0 ||
      rowsTrimmed > 0 ||
      rowsSkipped > 0 ||
      unknownUnits.isNotEmpty;
}
