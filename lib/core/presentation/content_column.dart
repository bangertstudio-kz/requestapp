import 'package:flutter/material.dart';

/// Ограничивает контент по ширине и центрирует его.
///
/// На широком окне строка в 1400 pt нечитаема: глаз теряет начало следующей
/// строки. Ограничение живёт здесь, а не в каждом экране, чтобы «широкое окно»
/// везде означало одно и то же число.
class ContentColumn extends StatelessWidget {
  const ContentColumn({
    super.key,
    required this.child,
    this.maxWidth = defaultMaxWidth,
  });

  /// Ширина телефонного макета плюс поля: список заявок на десктопе выглядит
  /// так же, как на телефоне, а не растягивается в таблицу, которой нет.
  static const double defaultMaxWidth = 560;

  /// Место плавающей кнопки: правый край колонки, а не окна.
  ///
  /// На широком окне кнопка у края экрана оказывается в полуметре от
  /// списка, к которому относится, — её ищут взглядом. На телефоне колонка
  /// во всю ширину, и место совпадает со стандартным.
  static const FloatingActionButtonLocation fabLocation = _ColumnEndFab();

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    // `heightFactor: 1` — не косметика. Без него `Align` занимает всю
    // доступную высоту, и в слоте `bottomNavigationBar`, который меряют
    // свободными констрейнтами, нижняя панель забирает экран целиком:
    // тело экрана получает нулевую высоту и не рисуется вовсе.
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

class _ColumnEndFab extends FloatingActionButtonLocation {
  const _ColumnEndFab();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final standard = FloatingActionButtonLocation.endFloat.getOffset(
      scaffoldGeometry,
    );
    final margin =
        (scaffoldGeometry.scaffoldSize.width - ContentColumn.defaultMaxWidth) /
        2;
    return margin > 0 ? standard.translate(-margin, 0) : standard;
  }
}
