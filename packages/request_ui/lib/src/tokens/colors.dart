import 'package:flutter/painting.dart';

/// Сырая палитра дизайн-системы: единственное место, где живут hex-константы.
///
/// Файл намеренно не экспортируется из `request_ui.dart` — приложение обязано
/// брать цвет по смыслу (`context.request.primary`), а не по значению.
/// Иначе перекраска темы превращается в поиск по литералам во всём проекте.
abstract final class AppColors {
  /// Синий действия. В макете это единственный акцент: он помечает то, что
  /// можно нажать, и больше ничего.
  static const Color blue = Color(0xFF23558F);
  static const Color blueDark = Color(0xFF1C477A);

  /// Заливка «слабого» действия и подсветка нажатия по нейтральному фону.
  static const Color blueTintSoft = Color(0xFFEEF3FA);
  static const Color blueTintSoftPressed = Color(0xFFE0EAF6);

  /// Фон выбранного состояния: пилюля активной вкладки, выбранная строка
  /// дерева, чип статуса «Отправлена».
  static const Color blueTint = Color(0xFFE7EEF8);

  /// Синий, потерявший право на нажатие: кнопка «Добавить в заявку» до того,
  /// как введено количество.
  static const Color blueMuted = Color(0xFFA9B6C6);

  /// Граница раскрытой подкатегории — слабее основной, чтобы вложенность
  /// читалась, но не спорила с выбранным материалом.
  static const Color blueBorderSoft = Color(0xFFA9C0DD);

  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF7F8F9);
  static const Color grey75 = Color(0xFFF2F5F8);
  static const Color grey100 = Color(0xFFF1F3F4);
  static const Color grey150 = Color(0xFFF0F2F3);
  static const Color grey200 = Color(0xFFEEF0F1);
  static const Color grey250 = Color(0xFFECEEF0);
  static const Color grey300 = Color(0xFFE2E5E7);
  static const Color grey350 = Color(0xFFDCDFE1);
  static const Color grey400 = Color(0xFFCFD4D7);
  static const Color grey450 = Color(0xFFC8CFD3);
  static const Color grey500 = Color(0xFFC3CBD0);

  static const Color ink = Color(0xFF14181A);
  static const Color ink700 = Color(0xFF3D4649);
  static const Color ink600 = Color(0xFF5B6467);
  static const Color ink500 = Color(0xFF6B7478);
  static const Color ink400 = Color(0xFF7A848A);
  static const Color ink300 = Color(0xFFA8B1B6);
  static const Color ink200 = Color(0xFFB6BEC2);

  /// Красный удаления. Приглушённый: удаление в этом приложении обратимо
  /// ровно до момента подтверждения, кричать нечем.
  static const Color red = Color(0xFF8B3A3A);
  static const Color redDark = Color(0xFF7A3131);
  static const Color redBorder = Color(0xFFE3CFCF);
  static const Color redTint = Color(0xFFF8EDED);

  /// Зелёный только в одном месте — чип «Сохранена».
  static const Color green = Color(0xFF2F6B4F);
  static const Color greenTint = Color(0xFFE6F0EA);

  /// Снек рисуется поверх контента и потому инвертирован.
  static const Color snackSurface = Color(0xFF1D2427);
  static const Color snackInk = Color(0xFFEEF0F1);
}

/// Палитра тёмной темы.
///
/// В макете её нет — подобрана по светлой: те же роли, тот же единственный
/// акцент, контраст текста и кнопок не ниже WCAG AA (4.5:1). Акцент
/// светлее светлого синего: `#23558F` на тёмном фоне почти не читается.
abstract final class AppDarkColors {
  static const Color blue = Color(0xFF8DB4E2);
  static const Color bluePressed = Color(0xFFA6C6EC);
  static const Color blueTintSoft = Color(0xFF1E2B3A);
  static const Color blueTintSoftPressed = Color(0xFF26374A);
  static const Color blueTint = Color(0xFF22354B);
  static const Color blueMuted = Color(0xFF3F5670);
  static const Color blueBorderSoft = Color(0xFF3E5D82);

  static const Color surface = Color(0xFF1A1F22);
  static const Color background = Color(0xFF111416);
  static const Color grey75 = Color(0xFF21272A);
  static const Color grey100 = Color(0xFF252B2E);
  static const Color grey150 = Color(0xFF2A3033);
  static const Color grey200 = Color(0xFF2A3034);
  static const Color grey250 = Color(0xFF2E3538);
  static const Color grey300 = Color(0xFF30383C);
  static const Color grey350 = Color(0xFF3A4347);
  static const Color grey400 = Color(0xFF465055);
  static const Color grey450 = Color(0xFF4B555A);
  static const Color grey500 = Color(0xFF58636A);

  static const Color ink = Color(0xFFE8ECEE);
  static const Color ink700 = Color(0xFFC9D0D3);
  static const Color ink600 = Color(0xFFAEB7BB);
  static const Color ink500 = Color(0xFF98A2A7);
  static const Color ink400 = Color(0xFF859095);
  static const Color ink300 = Color(0xFF5F6A6F);
  static const Color ink200 = Color(0xFF4F595D);

  static const Color red = Color(0xFFE08A8A);
  static const Color redPressed = Color(0xFFEBA3A3);
  static const Color redBorder = Color(0xFF5A3434);
  static const Color redTint = Color(0xFF2E1E1E);

  static const Color green = Color(0xFF7FC4A0);
  static const Color greenTint = Color(0xFF1E3329);

  /// Снек инвертирован и здесь: светлый поверх тёмного.
  static const Color snackSurface = Color(0xFFE8ECEE);
  static const Color snackInk = Color(0xFF14181A);
}
