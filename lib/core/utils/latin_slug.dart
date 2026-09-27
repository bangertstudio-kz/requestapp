/// Строка латиницей для имени файла: «Склад №3, расходники» →
/// `sklad-3-rashodniki`.
///
/// Транслитерация, а не кириллица как есть: файл уходит по почте на
/// чужой компьютер, и имя, которое там превратится в «%D0%97...», ищут
/// потом по дате изменения.
String latinSlug(String value) {
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    final replacement = _translit[char];
    if (replacement != null) {
      buffer.write(replacement);
    } else if (RegExp(r'[a-z0-9]').hasMatch(char)) {
      buffer.write(char);
    } else if (buffer.isNotEmpty && !buffer.toString().endsWith('-')) {
      // Всё остальное — один дефис подряд: «Склад №3, расходники»
      // не должно превращаться в «sklad---3--rashodniki».
      buffer.write('-');
    }
  }
  return buffer.toString().replaceAll(RegExp(r'-+$'), '');
}

const _translit = <String, String>{
  'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'e',
  'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm',
  'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
  'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh', 'щ': 'sch',
  'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya',
};
