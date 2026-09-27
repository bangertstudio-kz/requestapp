import 'package:flutter/painting.dart';

import '../tokens/typography.dart';

/// Текстовые роли, доступные через тему: `context.request.text.cardTitle`.
///
/// Отдельный объект, а не тридцать полей в [RequestTokens]: у текста своя
/// ось изменений (гарнитура, масштаб), и мешать её с цветовой — значит
/// править обе при каждой правке одной.
class RequestTextTheme {
  RequestTextTheme({
    required this.appBarTitle,
    required this.appBarSubtitle,
    required this.sectionLabel,
    required this.cardTitle,
    required this.itemTitle,
    required this.rowTitle,
    required this.treeCategoryTitle,
    required this.treeSubcategoryTitle,
    required this.treeMaterialTitle,
    required this.rowTitleStrong,
    required this.body,
    required this.bodySmall,
    required this.caption,
    required this.chip,
    required this.chipLarge,
    required this.statusChip,
    required this.buttonLarge,
    required this.buttonMedium,
    required this.buttonCompact,
    required this.buttonText,
    required this.fab,
    required this.quantityDisplay,
    required this.quantityUnit,
    required this.quantityValue,
    required this.quantityValueUnit,
    required this.keypadKey,
    required this.keypadKeyCompact,
    required this.meta,
    required this.sheetTitle,
    required this.sheetSubtitle,
    required this.materialTitle,
    required this.navLabel,
    required this.snack,
    required this.emptyState,
    required this.field,
    required this.fieldStrong,
    required this.fieldMedium,
    required this.fieldHint,
  });

  /// Роли из макета «Заявки на материалы».
  factory RequestTextTheme.standard() => RequestTextTheme(
          appBarTitle: AppTextStyles.appBarTitle,
          appBarSubtitle: AppTextStyles.appBarSubtitle,
          sectionLabel: AppTextStyles.sectionLabel,
          cardTitle: AppTextStyles.cardTitle,
          itemTitle: AppTextStyles.itemTitle,
          rowTitle: AppTextStyles.rowTitle,
          treeCategoryTitle: AppTextStyles.treeCategoryTitle,
          treeSubcategoryTitle: AppTextStyles.treeSubcategoryTitle,
          treeMaterialTitle: AppTextStyles.treeMaterialTitle,
          rowTitleStrong: AppTextStyles.rowTitleStrong,
          body: AppTextStyles.body,
          bodySmall: AppTextStyles.bodySmall,
          caption: AppTextStyles.caption,
          chip: AppTextStyles.chip,
          chipLarge: AppTextStyles.chipLarge,
          statusChip: AppTextStyles.statusChip,
          buttonLarge: AppTextStyles.buttonLarge,
          buttonMedium: AppTextStyles.buttonMedium,
          buttonCompact: AppTextStyles.buttonCompact,
          buttonText: AppTextStyles.buttonText,
          fab: AppTextStyles.fab,
          quantityDisplay: AppTextStyles.quantityDisplay,
          quantityUnit: AppTextStyles.quantityUnit,
          quantityValue: AppTextStyles.quantityValue,
          quantityValueUnit: AppTextStyles.quantityValueUnit,
          keypadKey: AppTextStyles.keypadKey,
          keypadKeyCompact: AppTextStyles.keypadKeyCompact,
          meta: AppTextStyles.meta,
          sheetTitle: AppTextStyles.sheetTitle,
          sheetSubtitle: AppTextStyles.sheetSubtitle,
          materialTitle: AppTextStyles.materialTitle,
          navLabel: AppTextStyles.navLabel,
          snack: AppTextStyles.snack,
          emptyState: AppTextStyles.emptyState,
          field: AppTextStyles.field,
          fieldStrong: AppTextStyles.fieldStrong,
          fieldMedium: AppTextStyles.fieldMedium,
          fieldHint: AppTextStyles.fieldHint,
      );

  /// Те же роли с заменой цвета — для тёмной темы. Цвет зашит в стили
  /// палитрой светлой, и [recolor] переводит его в пару из тёмной;
  /// цвета, которых нет в замене, остаются как были.
  RequestTextTheme recolored(Map<Color, Color> recolor) {
    TextStyle swap(TextStyle style) {
      final color = style.color;
      final next = color == null ? null : recolor[color];
      return next == null ? style : style.copyWith(color: next);
    }

    return RequestTextTheme(
      appBarTitle: swap(appBarTitle),
      appBarSubtitle: swap(appBarSubtitle),
      sectionLabel: swap(sectionLabel),
      cardTitle: swap(cardTitle),
      itemTitle: swap(itemTitle),
      rowTitle: swap(rowTitle),
      treeCategoryTitle: swap(treeCategoryTitle),
      treeSubcategoryTitle: swap(treeSubcategoryTitle),
      treeMaterialTitle: swap(treeMaterialTitle),
      rowTitleStrong: swap(rowTitleStrong),
      body: swap(body),
      bodySmall: swap(bodySmall),
      caption: swap(caption),
      chip: swap(chip),
      chipLarge: swap(chipLarge),
      statusChip: swap(statusChip),
      buttonLarge: swap(buttonLarge),
      buttonMedium: swap(buttonMedium),
      buttonCompact: swap(buttonCompact),
      buttonText: swap(buttonText),
      fab: swap(fab),
      quantityDisplay: swap(quantityDisplay),
      quantityUnit: swap(quantityUnit),
      quantityValue: swap(quantityValue),
      quantityValueUnit: swap(quantityValueUnit),
      keypadKey: swap(keypadKey),
      keypadKeyCompact: swap(keypadKeyCompact),
      meta: swap(meta),
      sheetTitle: swap(sheetTitle),
      sheetSubtitle: swap(sheetSubtitle),
      materialTitle: swap(materialTitle),
      navLabel: swap(navLabel),
      snack: swap(snack),
      emptyState: swap(emptyState),
      field: swap(field),
      fieldStrong: swap(fieldStrong),
      fieldMedium: swap(fieldMedium),
      fieldHint: swap(fieldHint),
    );
  }

  final TextStyle appBarTitle;
  final TextStyle appBarSubtitle;
  final TextStyle sectionLabel;
  final TextStyle cardTitle;
  final TextStyle itemTitle;
  final TextStyle rowTitle;
  final TextStyle treeCategoryTitle;
  final TextStyle treeSubcategoryTitle;
  final TextStyle treeMaterialTitle;
  final TextStyle rowTitleStrong;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle caption;
  final TextStyle chip;
  final TextStyle chipLarge;
  final TextStyle statusChip;
  final TextStyle buttonLarge;
  final TextStyle buttonMedium;
  final TextStyle buttonCompact;
  final TextStyle buttonText;
  final TextStyle fab;
  final TextStyle quantityDisplay;
  final TextStyle quantityUnit;
  final TextStyle quantityValue;
  final TextStyle quantityValueUnit;
  final TextStyle keypadKey;
  final TextStyle keypadKeyCompact;
  final TextStyle meta;
  final TextStyle sheetTitle;
  final TextStyle sheetSubtitle;
  final TextStyle materialTitle;
  final TextStyle navLabel;
  final TextStyle snack;
  final TextStyle emptyState;
  final TextStyle field;
  final TextStyle fieldStrong;
  final TextStyle fieldMedium;
  final TextStyle fieldHint;
}
