/// Размеры дизайн-системы: радиусы, отступы и высоты управляющих элементов.
///
/// Числа дробные там, где дробные в макете (15.5, 12.5): округление «для
/// красоты» смещает базовые линии и ломает совпадение с прототипом.
abstract final class AppDimens {
  // ── Отступы ───────────────────────────────────────────────────────────
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space14 = 14;
  static const double space16 = 16;
  static const double space18 = 18;
  static const double space22 = 22;
  static const double space26 = 26;

  /// Боковое поле экрана. Карточки живут внутри него, заголовки секций —
  /// на 2 пункта глубже (18), чтобы подпись висела над рамкой, а не на ней.
  static const double screenPadding = 16;
  static const double labelPadding = 18;

  // ── Радиусы ───────────────────────────────────────────────────────────
  static const double radiusBadge = 6;
  static const double radiusStatus = 7;
  static const double radiusChip = 9;
  static const double radiusButtonSmall = 10;
  static const double radiusButton = 11;
  static const double radiusControl = 12;
  static const double radiusCard = 14;
  static const double radiusFab = 16;
  static const double radiusSheet = 20;

  // ── Высоты ────────────────────────────────────────────────────────────
  /// Зона нажатия. Всё, что меньше [touchTargetMin], — промах пальцем;
  /// приложением пользуются на объекте, часто в перчатках.
  ///
  /// Визуальный размер элемента может быть меньше зоны нажатия — но не сама
  /// зона: прозрачные поля вокруг иконки ничего не стоят, а промах стоит
  /// удалённой позиции в заявке.
  static const double touchTarget = 48;
  static const double touchTargetMin = 44;

  static const double buttonLarge = 54;
  static const double buttonMedium = 48;
  static const double buttonSmall = 44;
  static const double chipHeight = 42;
  static const double fabHeight = 56;
  static const double fieldHeight = 50;
  static const double keyHeight = 58;
  static const double keyHeightCompact = 50;
  static const double rowHeight = 54;
  static const double rowHeightCategory = 58;
  static const double rowHeightSubcategory = 52;

  /// Ручка шторки: единственная подсказка, что панель тянется вниз.
  static const double sheetHandleWidth = 36;
  static const double sheetHandleHeight = 4;
}
