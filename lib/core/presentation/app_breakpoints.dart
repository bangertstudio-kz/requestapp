import 'package:flutter/widgets.dart';

/// Ширина окна в терминах вёрстки.
///
/// Две ступени, а не четыре. Планшет ведёт себя как десктоп: нижняя панель на
/// 1000 pt — это два сантиметра пустоты по краям и палец, тянущийся через весь
/// экран. Промежуточные ступени добавляют ветвлений больше, чем смысла;
/// третью заводим тогда, когда появится макет, который её требует.
enum AppWidth {
  phone,
  desktop;

  /// Граница совпадает с шириной, на которой два столбца перестают быть уже
  /// читаемой строки.
  static const double desktopMinWidth = 840;

  static AppWidth of(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopMinWidth
      ? AppWidth.desktop
      : AppWidth.phone;

  bool operator >=(AppWidth other) => index >= other.index;
  bool operator <=(AppWidth other) => index <= other.index;
  bool operator >(AppWidth other) => index > other.index;
  bool operator <(AppWidth other) => index < other.index;
}
