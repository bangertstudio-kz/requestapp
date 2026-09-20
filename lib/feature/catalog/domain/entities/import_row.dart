import 'item_unit.dart';

/// Одна разобранная строка файла импорта.
class ImportRow {
  const ImportRow({
    required this.path,
    required this.name,
    required this.unit,
  });

  /// Вложенные категории относительно выбранной, от неё вниз.
  /// Пусто — материал ложится прямо в выбранную категорию.
  final List<String> path;

  final String name;
  final ItemUnit unit;
}
