import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_item.dart';
import 'item_path_label.dart';
import 'item_unit_label.dart';
import 'quantity_controller.dart';
import 'quantity_sheet.dart';

/// Подбор материала: поиск по всему справочнику, дерево категорий и
/// количество в шторке снизу.
///
/// Один экран на весь путь «категория → подкатегория → материал → количество».
/// Разложить его на четыре экрана значит заставить монтажника, набирающего
/// двадцать позиций, пройти восемьдесят переходов.
///
/// Список длинный по устройству предметной области: 326 материалов, в ППР —
/// 154. Поэтому строка поиска не уезжает вверх, раскрытые заголовки
/// прилипают к верху, а из глубины списка есть возврат к началу.
class ItemPickScreen extends StatefulWidget {
  const ItemPickScreen({
    super.key,
    required this.categories,
    required this.searchResults,
    required this.searchLoading,
    required this.searchController,
    required this.onSearchChanged,
    required this.selected,
    required this.onSelected,
    required this.onSelectionCleared,
    required this.quantityController,
    required this.onAdd,
    required this.onBack,
  });

  final List<CatalogCategory> categories;

  /// Результат поиска или `null`, если строка поиска пуста. `null`, а не
  /// пустой список: «ничего не найдено» и «ничего не искали» — разные экраны.
  final List<CatalogItem>? searchResults;

  /// Первый поиск ещё идёт и результатов пока нет.
  ///
  /// Без этого флага пустой список читается как «ничего не найдено» — то
  /// есть экран отвечает на вопрос раньше, чем успел его обработать.
  final bool searchLoading;

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  final CatalogItem? selected;
  final ValueChanged<CatalogItem> onSelected;
  final VoidCallback onSelectionCleared;

  final QuantityController quantityController;
  final void Function(CatalogItem item, int quantity) onAdd;
  final VoidCallback onBack;

  @override
  State<ItemPickScreen> createState() => _ItemPickScreenState();
}

class _ItemPickScreenState extends State<ItemPickScreen> {
  /// Расстояние, после которого возврат к началу перестаёт быть жестом
  /// «пролистать обратно» и становится отдельной работой.
  static const double _scrollTopThreshold = 600;

  final _scrollController = ScrollController();

  /// Отдельный `ValueNotifier`, а не `setState`: скролл уведомляет на каждом
  /// кадре, и перестраивать всё дерево ради одной кнопки — это подтормаживание
  /// ровно в тот момент, когда список листают.
  final _scrolledDeep = ValueNotifier<bool>(false);

  /// Раскрытые ветки. Множество, а не два идентификатора: глубина дерева
  /// больше не ограничена, и «раскрытая категория плюс раскрытая
  /// подкатегория» перестало описывать состояние.
  ///
  /// На входе пусто: экран открывается свёрнутым списком категорий, и
  /// раскрытая наугад первая заставляла сначала её сворачивать.
  final _expanded = <String>{};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrolledDeep.dispose();
    super.dispose();
  }

  /// Отступу отдаётся всё, кроме места под название. Предела глубины нет —
  /// есть предел ширины: дальше строки перестают сдвигаться и продолжают
  /// читаться.
  static double _maxIndentFor(BuildContext context) {
    final free =
        MediaQuery.sizeOf(context).width -
        AppDimens.screenPadding * 2 -
        _minRowWidth;
    return free < 0 ? 0 : free;
  }

  static const _minRowWidth = 180.0;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    _scrolledDeep.value = _scrollController.offset > _scrollTopThreshold;
  }

  void _scrollToTop() => _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOutCubic,
  );

  void _toggle(CatalogCategory category) {
    final opened = !_expanded.remove(category.id);
    setState(() {
      if (opened) _expanded.add(category.id);
    });
    // Свернули ветку — список стал коротким, и позиция скролла из середины
    // раскрытой категории оказывается за его концом.
    if (!opened) _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = widget.searchResults;
    final selected = widget.selected;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Stack(
            children: [
              Column(
                children: [
                  AppTopBar(
                    title: l10n.pickTitle,
                    subtitle: l10n.pickSubtitle,
                    onBack: widget.onBack,
                    backSemanticLabel: l10n.actionBack,
                  ),
                  // Поиск живёт над списком, а не в нём: при 326 материалах он
                  // главный инструмент экрана и уезжать вверх не должен.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.screenPadding,
                      0,
                      AppDimens.screenPadding,
                      AppDimens.space12,
                    ),
                    child: AppSearchField(
                      controller: widget.searchController,
                      hintText: l10n.pickSearchHint,
                      clearSemanticLabel: l10n.actionClearSearch,
                      onChanged: widget.onSearchChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.labelPadding,
                      AppDimens.space2,
                      AppDimens.labelPadding,
                      AppDimens.space8,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AppSectionLabel(switch ((
                        results,
                        widget.searchLoading,
                      )) {
                        (null, _) => l10n.pickHintTree,
                        (_, true) => l10n.pickSearching,
                        (final found?, _) => l10n.pickHintFound(found.length),
                      }),
                    ),
                  ),
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            AppDimens.screenPadding,
                            0,
                            AppDimens.screenPadding,
                            // Под открытой шторкой список получает высокий
                            // хвост: выбранную строку должно быть видно над
                            // шторкой, иначе непонятно, к чему относится
                            // введённое количество.
                            selected == null ? 40 : 520,
                          ),
                          sliver: results == null
                              ? _TreeSlivers(
                                  categories: widget.categories,
                                  expanded: _expanded,
                                  selectedId: widget.selected?.id,
                                  onCategoryTap: _toggle,
                                  onItemTap: widget.onSelected,
                                  // Сколько ширины можно отдать отступу,
                                  // оставив название читаемым.
                                  maxIndent: _maxIndentFor(context),
                                )
                              : _searchSliver(l10n, results),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (selected == null)
                Positioned(
                  right: AppDimens.screenPadding,
                  bottom: AppDimens.space22,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _scrolledDeep,
                    builder: (context, visible, _) => AppScrollTopButton(
                      label: l10n.pickScrollTop,
                      visible: visible,
                      onPressed: _scrollToTop,
                    ),
                  ),
                ),
              if (selected != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: QuantitySheet(
                    item: selected,
                    controller: widget.quantityController,
                    onAdd: (quantity) => widget.onAdd(selected, quantity),
                    onClose: widget.onSelectionCleared,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchSliver(AppLocalizations l10n, List<CatalogItem> results) {
    if (results.isEmpty) {
      if (widget.searchLoading) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppDimens.space26),
            child: Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: context.request.primary,
                ),
              ),
            ),
          ),
        );
      }
      return SliverToBoxAdapter(
        child: AppEmptyState(message: l10n.pickNothingFound),
      );
    }
    return SliverList.separated(
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.space6),
      itemBuilder: (context, index) {
        final item = results[index];
        return AppTreeRow.material(
          title: item.name,
          // Путь во второй строке: в плоском результате поиска у «Трубы ⌀25»
          // из ППР и из металлопластика одинаковое название и одна единица.
          subtitle: itemPathLabel(l10n, item.path),
          meta: itemUnitLabel(l10n, item.unit),
          selected: widget.selected?.id == item.id,
          // Сдвигать строку вправо, когда слева ничего нет, — обещать
          // иерархию, которой в результате поиска не видно.
          nested: false,
          onTap: () => widget.onSelected(item),
        );
      },
    );
  }
}

/// Дерево категорий как набор sliver'ов.
///
/// Раскрытая строка становится прилипающим заголовком: в ППР 154 материала,
/// и на пятом экране прокрутки без заголовка уже не видно, в какой ты
/// категории и подкатегории.
class _TreeSlivers extends StatelessWidget {
  const _TreeSlivers({
    required this.categories,
    required this.expanded,
    required this.selectedId,
    required this.onCategoryTap,
    required this.onItemTap,
    required this.maxIndent,
  });

  final List<CatalogCategory> categories;

  /// Раскрытые ветки любого уровня.
  final Set<String> expanded;

  final String? selectedId;
  final ValueChanged<CatalogCategory> onCategoryTap;
  final ValueChanged<CatalogItem> onItemTap;

  /// Докуда разрешено уезжать отступу. Дальше он перестаёт расти: на пятом
  /// уровне название иначе сжимается в многоточие, и дерево перестаёт
  /// отвечать на вопрос, ради которого его открыли.
  final double maxIndent;

  static const _indentStep = AppDimens.space14;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slivers = <Widget>[];
    _append(slivers, l10n, categories, 0);
    return SliverMainAxisGroup(slivers: slivers);
  }

  void _append(
    List<Widget> slivers,
    AppLocalizations l10n,
    List<CatalogCategory> level,
    int depth,
  ) {
    for (final category in level) {
      final open = expanded.contains(category.id);
      final meta = open
          ? l10n.pickCollapseMark
          : l10n.pickCategoryMeta(
              category.categories.length,
              _countItems(category),
            );

      final row = depth == 0
          ? AppTreeRow.category(
              title: category.name,
              meta: meta,
              expanded: open,
              onTap: () => onCategoryTap(category),
            )
          : AppTreeRow.subcategory(
              title: category.name,
              meta: meta,
              expanded: open,
              extraIndent: _indentOf(depth - 1),
              onTap: () => onCategoryTap(category),
            );

      slivers.add(
        open
            ? _pinned(
                row,
                depth == 0
                    ? AppDimens.rowHeightCategory
                    : AppDimens.rowHeightSubcategory,
              )
            : _spaced(row),
      );
      if (!open) continue;

      // Сначала вложенные ветки, потом материалы: тот же порядок, что
      // в списке внутри категории.
      _append(slivers, l10n, category.categories, depth + 1);

      if (category.items.isNotEmpty) {
        final indent = _indentOf(depth);
        slivers.add(
          SliverList.separated(
            itemCount: category.items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimens.space6),
            itemBuilder: (context, index) {
              final item = category.items[index];
              return AppTreeRow.material(
                title: item.name,
                meta: itemUnitLabel(l10n, item.unit),
                selected: selectedId == item.id,
                extraIndent: indent,
                onTap: () => onItemTap(item),
              );
            },
          ),
        );
        slivers.add(
          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.space6)),
        );
      }
    }
  }

  /// Отступ растёт свободно и упирается там, где строке перестаёт хватать
  /// места. Жёсткого предела глубины нет — ограничена ширина экрана.
  double _indentOf(int depth) {
    final wanted = depth * _indentStep;
    return wanted > maxIndent ? maxIndent : wanted;
  }

  static int _countItems(CatalogCategory category) =>
      category.items.length +
      category.categories.fold(0, (n, child) => n + _countItems(child));

  /// Свёрнутая строка: обычная, с промежутком снизу.
  Widget _spaced(Widget row) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space6),
      child: row,
    ),
  );

  /// Раскрытая строка прилипает к верху: в ППР 154 позиции, и на пятом
  /// экране прокрутки без заголовка не видно, в какой ты ветке.
  Widget _pinned(Widget row, double height) => SliverPersistentHeader(
    pinned: true,
    delegate: _PinnedRowDelegate(row: row, rowHeight: height),
  );
}

class _PinnedRowDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedRowDelegate({required this.row, required this.rowHeight});

  final Widget row;
  final double rowHeight;

  /// Промежуток входит в высоту заголовка: иначе прилипшая строка стоит
  /// вплотную к следующей и перестаёт читаться как отдельный уровень.
  double get _extent => rowHeight + AppDimens.space6;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      // Непрозрачная подложка обязательна: под прилипшей строкой проезжает
      // список, и без фона он просвечивает сквозь промежуток.
      //
      // Тень появляется только когда под заголовком действительно что-то
      // едет: без неё срез проезжающей карточки читается как artefact
      // отрисовки, а не как «список продолжается ниже».
      DecoratedBox(
        decoration: BoxDecoration(
          color: context.request.background,
          boxShadow: overlapsContent
              ? [
                  BoxShadow(
                    color: context.request.ink.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.space6),
          child: row,
        ),
      );

  @override
  bool shouldRebuild(_PinnedRowDelegate oldDelegate) =>
      oldDelegate.row != row || oldDelegate.rowHeight != rowHeight;
}
