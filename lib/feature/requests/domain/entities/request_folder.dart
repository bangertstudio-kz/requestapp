/// Папка, в которой лежат заявки.
///
/// Один уровень вложенности: дерево папок на телефоне ищется дольше,
/// чем поиском по названию.
class RequestFolder {
  const RequestFolder({
    required this.id,
    required this.name,
    required this.requestCount,
  });

  final String id;
  final String name;

  /// Сколько заявок внутри. Приезжает вместе с папкой, а не считается
  /// экраном: считать по загруженному списку можно только те заявки,
  /// что уже загружены, а список отфильтрован.
  final int requestCount;
}
