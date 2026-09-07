import 'package:flutter/painting.dart';

import 'colors.dart';

/// Гарнитуры. Числа и единицы измерения — моноширинные: в списке материалов
/// количества стоят колонкой, и пропорциональный шрифт эту колонку разваливает.
abstract final class AppFonts {
  static const String sans = 'IBMPlexSans';
  static const String mono = 'IBMPlexMono';

  /// Шрифты лежат в пакете, поэтому каждый стиль обязан назвать пакет —
  /// иначе Flutter ищет семейство в ассетах приложения и молча берёт системное.
  static const String package = 'request_ui';
}

/// Текстовые стили дизайн-системы.
///
/// Цвет по умолчанию вшит в стиль: у каждой роли в макете он ровно один.
/// Там, где роль переиспользуется в другом цвете (заголовок на тёмном снеке),
/// вызывающий делает `copyWith` — это редкий случай, а не правило.
abstract final class AppTextStyles {
  static const TextStyle _sans = TextStyle(
    fontFamily: AppFonts.sans,
    package: AppFonts.package,
    color: AppColors.ink,
  );

  static const TextStyle _mono = TextStyle(
    fontFamily: AppFonts.mono,
    package: AppFonts.package,
    color: AppColors.ink,
  );

  // ── Шапка экрана ──────────────────────────────────────────────────────
  static final TextStyle appBarTitle = _sans.copyWith(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.21,
  );
  static final TextStyle appBarSubtitle = _sans.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.ink500,
  );

  /// Подпись секции. Регистр поднимает виджет, а не стиль: `toUpperCase`
  /// в стиле невозможен, а дублировать его на каждом вызове — забыть на третьем.
  static final TextStyle sectionLabel = _sans.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: AppColors.ink400,
  );

  // ── Карточки и строки ─────────────────────────────────────────────────
  static final TextStyle cardTitle = _sans.copyWith(
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.165,
  );
  static final TextStyle itemTitle = _sans.copyWith(
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle rowTitle = _sans.copyWith(
    fontSize: 15.5,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  static final TextStyle rowTitleStrong = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Строки дерева в подборе материала: три уровня, три веса. Разница в
  /// полпункта здесь несёт всю иерархию — отступа слева для этого мало.
  static final TextStyle treeCategoryTitle = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle treeSubcategoryTitle = _sans.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle treeMaterialTitle = _sans.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static final TextStyle body = _sans.copyWith(fontSize: 15.5);
  static final TextStyle bodySmall = _sans.copyWith(
    fontSize: 13,
    color: AppColors.ink500,
  );
  static final TextStyle caption = _sans.copyWith(
    fontSize: 12.5,
    color: AppColors.ink400,
  );

  // ── Чипы ──────────────────────────────────────────────────────────────
  static final TextStyle chip = _sans.copyWith(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle chipLarge = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle statusChip = _sans.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.23,
  );

  // ── Кнопки ────────────────────────────────────────────────────────────
  static final TextStyle buttonLarge = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle buttonMedium = _sans.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle buttonCompact = _sans.copyWith(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle buttonText = _sans.copyWith(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fab = _sans.copyWith(
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.155,
  );

  // ── Числа ─────────────────────────────────────────────────────────────
  /// Табло количества в шторке и на экране позиции.
  static final TextStyle quantityDisplay = _mono.copyWith(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    height: 1,
  );
  static final TextStyle quantityUnit = _mono.copyWith(
    fontSize: 16,
    color: AppColors.ink500,
  );
  static final TextStyle quantityValue = _mono.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle quantityValueUnit = _mono.copyWith(
    fontSize: 13,
    color: AppColors.ink500,
  );
  static final TextStyle keypadKey = _mono.copyWith(
    fontSize: 21,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle keypadKeyCompact = _mono.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle meta = _mono.copyWith(
    fontSize: 12.5,
    color: AppColors.ink400,
  );

  // ── Шторки, навигация, снек ───────────────────────────────────────────
  static final TextStyle sheetTitle = _sans.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static final TextStyle sheetSubtitle = _sans.copyWith(
    fontSize: 13.5,
    height: 1.45,
    color: AppColors.ink400,
  );
  static final TextStyle materialTitle = _sans.copyWith(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.19,
  );
  static final TextStyle navLabel = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle snack = _sans.copyWith(
    fontSize: 14,
    height: 1.4,
    color: AppColors.snackInk,
  );
  static final TextStyle emptyState = _sans.copyWith(
    fontSize: 14,
    height: 1.5,
    color: AppColors.ink400,
  );

  // ── Поля ввода ────────────────────────────────────────────────────────
  static final TextStyle field = _sans.copyWith(fontSize: 15.5);
  static final TextStyle fieldStrong = _sans.copyWith(
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle fieldMedium = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fieldHint = _sans.copyWith(
    fontSize: 15.5,
    color: AppColors.ink400,
  );
}
