/// Что даст импорт, если его подтвердить.
///
/// Считается при разборе файла, до того как справочник тронут. Пользователь
/// должен увидеть цифры и предупреждения раньше, чем нажмёт «Добавить»:
/// разбирается чужой файл, и «сначала загрузим, потом посмотрим» здесь
/// означает чужой порядок в справочнике без предупреждения.
class CatalogImportSummary {
  const CatalogImportSummary({
    required this.fileName,
    required this.targetPath,
    required this.itemsAdded,
    required this.itemsUpdated,
    required this.categoriesCreated,
    required this.duplicatesRemoved,
    required this.rowsTrimmed,
    required this.rowsSkipped,
    required this.unknownUnits,
  });

  final String fileName;

  /// Путь категории, в которую грузим. Пусто — корень справочника.
  final List<String> targetPath;

  /// Материалов появится впервые.
  final int itemsAdded;

  /// Материалов уже есть в той же ветке под тем же названием — им
  /// обновится единица измерения.
  ///
  /// Отдельно от [itemsAdded], потому что это разные обещания: «добавится 40»
  /// и «40 записей перезапишутся» человек взвешивает по-разному.
  final int itemsUpdated;

  /// Веток, которых в справочнике ещё нет и которые создаст импорт.
  final int categoriesCreated;

  /// Полностью совпадающие строки файла.
  final int duplicatesRemoved;

  /// Строки, где потребовался trim и сжатие пробелов. Показываем числом,
  /// а не списком: важно, что правки были, а не какие именно.
  final int rowsTrimmed;

  /// Строки без названия — загружать нечего.
  final int rowsSkipped;

  /// Единицы измерения из файла, которых нет среди трёх допустимых.
  /// Список, а не счётчик: чтобы исправить файл, нужно знать, что писать.
  final List<String> unknownUnits;

  /// Есть ли что показать в блоке предупреждений.
  bool get hasWarnings =>
      duplicatesRemoved > 0 ||
      rowsTrimmed > 0 ||
      rowsSkipped > 0 ||
      unknownUnits.isNotEmpty;
}
