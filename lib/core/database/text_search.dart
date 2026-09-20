/// Приведение названия к виду, в котором лежит колонка `name_lower`.
///
/// Одна функция на все пути записи: колонка полезна ровно до тех пор, пока
/// её заполняют одинаково. Регистр снимает Dart, а не SQLite, потому что
/// `lower()` в SQLite трогает только латиницу.
String normalizedName(String value) => value.trim().toLowerCase();

/// Символ экранирования в шаблонах `LIKE`.
const likeEscapeChar = '\\';

/// Шаблон «содержит подстроку» для `LIKE ... ESCAPE`.
///
/// `%` и `_` из запроса экранируются: человек, ищущий «раствор 5%»,
/// имеет в виду проценты, а не «что угодно после пятёрки».
String containsPattern(String query) {
  final escaped = normalizedName(query)
      .replaceAll(likeEscapeChar, '$likeEscapeChar$likeEscapeChar')
      .replaceAll('%', '$likeEscapeChar%')
      .replaceAll('_', '${likeEscapeChar}_');
  return '%$escaped%';
}
