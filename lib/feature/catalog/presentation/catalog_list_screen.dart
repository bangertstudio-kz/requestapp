import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';

/// Раздел корневого экрана справочника.
enum CatalogTab { categories, items }

/// Список справочника: категории, подкатегории или материалы.
///
/// Один экран на все три уровня, потому что все три — это «список записей,
/// заголовок, кнопка добавления». Три файла с одинаковой вёрсткой расходятся
/// на первой же правке отступа.
class CatalogListScreen extends StatelessWidget {
  const CatalogListScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.itemCount,
    required this.itemBuilder,
    required this.emptyMessage,
    required this.fabLabel,
    required this.onFabPressed,
    this.actions = const [],
    this.tab,
    this.onTabSelected,
    this.onBack,
  });

  final String title;
  final String subtitle;

  /// Подпись над списком со счётчиком: «КАТЕГОРИИ · 6».
  final String label;

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  /// Подсказка на пустом списке. Обязательна: пустой справочник — обычное
  /// состояние сразу после установки, и белый экран в этот момент не
  /// сообщает, что делать дальше.
  final String emptyMessage;

  /// Действия в шапке — например, импорт прайса на корневом экране.
  final List<Widget> actions;

  final String fabLabel;
  final VoidCallback onFabPressed;

  /// Вкладки есть только на корневом экране: внутри категории переключать
  /// нечего — там один список.
  final CatalogTab? tab;
  final ValueChanged<CatalogTab>? onTabSelected;

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentTab = tab;

    return Scaffold(
      floatingActionButton: AppFab(label: fabLabel, onPressed: onFabPressed),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: title,
                subtitle: subtitle,
                onBack: onBack,
                backSemanticLabel: l10n.actionBack,
                actions: actions,
              ),
              if (currentTab != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.screenPadding,
                    AppDimens.space2,
                    AppDimens.screenPadding,
                    AppDimens.space14,
                  ),
                  child: Row(
                    children: [
                      for (final value in CatalogTab.values) ...[
                        Expanded(
                          child: AppChip(
                            style: AppChipStyle.tab,
                            label: switch (value) {
                              CatalogTab.categories =>
                                l10n.catalogTabCategories,
                              CatalogTab.items => l10n.catalogTabMaterials,
                            },
                            selected: value == currentTab,
                            onTap: () => onTabSelected?.call(value),
                          ),
                        ),
                        if (value != CatalogTab.values.last)
                          const SizedBox(width: AppDimens.space8),
                      ],
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.labelPadding,
                  0,
                  AppDimens.labelPadding,
                  AppDimens.space8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppSectionLabel(label),
                ),
              ),
              Expanded(
                child: itemCount == 0
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          0,
                          AppDimens.screenPadding,
                          130,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: AppEmptyState(message: emptyMessage),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          0,
                          AppDimens.screenPadding,
                          130,
                        ),
                        itemCount: itemCount,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppDimens.space8),
                        itemBuilder: itemBuilder,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
