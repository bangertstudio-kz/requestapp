import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Начертание чипа. В макете их четыре, и каждое привязано к месту:
/// фильтр над списком, вкладка справочника, выбор категории в форме,
/// выбор единицы измерения.
enum AppChipStyle {
  /// Фильтр заявок: высота задаётся отступами, чтобы ряд не выглядел панелью.
  filter,

  /// Вкладка справочника: равные доли ширины.
  tab,

  /// Выбор в форме: категория и подкатегория переносятся по строкам.
  choice,

  /// Единица измерения — моноширинная, потому что стоит рядом с числами.
  unit,
}

/// Выбор одного значения из ряда. Невыбранный — белый с рамкой,
/// выбранный — залит акцентом: третьего состояния в макете нет.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.style = AppChipStyle.filter,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppChipStyle style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(switch (style) {
      AppChipStyle.filter || AppChipStyle.tab => AppDimens.radiusChip,
      AppChipStyle.choice => AppDimens.radiusButtonSmall,
      AppChipStyle.unit => AppDimens.radiusButton,
    });
    final height = switch (style) {
      AppChipStyle.filter => null,
      AppChipStyle.tab || AppChipStyle.choice => AppDimens.chipHeight,
      AppChipStyle.unit => 46.0,
    };
    final padding = switch (style) {
      AppChipStyle.filter => const EdgeInsets.symmetric(
          horizontal: AppDimens.space14,
          vertical: 9,
        ),
      AppChipStyle.tab || AppChipStyle.unit => EdgeInsets.zero,
      AppChipStyle.choice =>
        const EdgeInsets.symmetric(horizontal: AppDimens.space14),
    };
    final baseStyle = switch (style) {
      AppChipStyle.filter || AppChipStyle.tab => tokens.text.chip,
      AppChipStyle.choice => tokens.text.chipLarge,
      AppChipStyle.unit => tokens.text.quantityUnit.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
    };

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? tokens.primary : tokens.surface,
          borderRadius: radius,
          border: Border.all(
            color: selected ? tokens.primary : tokens.borderStrong,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: padding,
              child: Center(
                // Чип шириной по содержимому. Без множителя `Center`
                // растягивается на всю доступную ширину, и ряд чипов
                // в `Wrap` превращается в столбец из кнопок во весь экран.
                // Там, где чип обёрнут в `Expanded` (вкладки, единицы),
                // жёсткие констрейнты родителя всё равно сильнее.
                widthFactor: 1,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: baseStyle.copyWith(
                    color: selected ? tokens.surface : tokens.inkChip,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
