import 'dart:ui';

/// Язык интерфейса.
///
/// Перечисление, а не голая `Locale`: в сохранённом файле лежит имя
/// значения, и опечатка в нём — просто незнакомое имя, а не локаль,
/// которой нет среди переводов.
enum AppLanguage {
  ru(Locale('ru')),
  en(Locale('en')),
  kk(Locale('kk')),

  /// Кошачий. Русский в основе — числа, даты и склонения берутся оттуда,
  /// а своими у него только слова.
  cat(Locale('ru', 'CAT'));

  const AppLanguage(this.locale);

  final Locale locale;

  /// Язык по имени из хранилища; незнакомое — `null`.
  static AppLanguage? byName(String name) =>
      values.where((value) => value.name == name).firstOrNull;
}
