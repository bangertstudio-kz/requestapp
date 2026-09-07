import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_material.dart';
import 'material_unit_label.dart';
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
class MaterialPickScreen extends StatefulWidget {
  const MaterialPickScreen({
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
  final List<CatalogMaterial>? searchResults;

  /// Первый поиск ещё идёт и результатов пока нет.
  ///
  /// Без этого флага пустой список читается как «ничего не найдено» — то
  /// есть экран отвечает на вопрос раньше, чем успел его обработать.
  final bool searchLoading;

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  final CatalogMaterial? selected;
  final ValueChanged<CatalogMaterial> onSelected;
  final VoidCallback onSelectionCleared;

  final QuantityController quantityController;
  final void Function(CatalogMaterial material, int quantity) onAdd;
  final VoidCallback onBack;

  @override
  State<MaterialPickScreen> createState() => _MaterialPickScreenState();
}

class _MaterialPickScreenState extends State<MaterialPickScreen> {
  /// Расстояние, после которого возврат к началу перестаёт быть жестом
  /// «пролистать обратно» и становится отдельной работой.
  static const double _scrollTopThreshold = 600;

  final _scrollController = ScrollController();

  /// Отдельный `ValueNotifier`, а не `setState`: скролл уведомляет на каждом
  /// кадре, и перестраивать всё дерево ради одной кнопки — это подтормаживание
  /// ровно в тот момент, когда список листают.
  final _scrolledDeep = ValueNotifier<bool>(false);

  /// Раскрыта одна ветка за раз. Дерево из шести категорий, раскрытых
  /// одновременно, — это 326 строк, по которым уже нельзя пролистать.
  String? _expandedCategoryId;
  String? _expandedSubcategoryId;

  @override
  void initState() {
    super.initState();
    // Первая категория раскрыта сразу: свёрнутый список из шести строк
    // не подсказывает, что строки разворачиваются.
    _expandedCategoryId = widget.categories.firstOrNull?.id;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrolledDeep.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    _scrolledDeep.value = _scrollController.offset > _scrollTopThreshold;
  }

  void _scrollToTop() => _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOutCubic,
  );

  void _toggleCategory(CatalogCategory category) {
    setState(() {
      final wasOpen = _expandedCategoryId == category.id;
      _expandedCategoryId = wasOpen ? null : category.id;
      _expandedSubcategoryId = null;
    });
    // Свернули ветку — список стал коротким, и позиция скролла из середины
    // раскрытой категории оказывается за его концом.
    _scrollToTop();
  }

  void _toggleSubcategory(String id) => setState(() {
    _expandedSubcategoryId = _expandedSubcategoryId == id ? null : id;
  });

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
                                  expandedCategoryId: _expandedCategoryId,
                                  expandedSubcategoryId: _expandedSubcategoryId,
                                  selectedId: widget.selected?.id,
                                  onCategoryTap: _toggleCategory,
                                  onSubcategoryTap: _toggleSubcategory,
                                  onMaterialTap: widget.onSelected,
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
                    material: selected,
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

  Widget _searchSliver(AppLocalizations l10n, List<CatalogMaterial> results) {
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
        final material = results[index];
        return AppTreeRow.material(
          title: material.name,
          // Путь во второй строке: в плоском результате поиска у «Трубы ⌀25»
          // из ППР и из металлопластика одинаковое название и одна единица.
          subtitle: l10n.materialPath(
            material.categoryName,
            material.subcategoryName,
          ),
          meta: materialUnitLabel(l10n, material.unit),
          selected: widget.selected?.id == material.id,
          // Сдвигать строку вправо, когда слева ничего нет, — обещать
          // иерархию, которой в результате поиска не видно.
          nested: false,
          onTap: () => widget.onSelected(material),
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
    required this.expandedCategoryId,
    required this.expandedSubcategoryId,
    required this.selectedId,
    required this.onCategoryTap,
    required this.onSubcategoryTap,
    required this.onMaterialTap,
  });

  final List<CatalogCategory> categories;
  final String? expandedCategoryId;
  final String? expandedSubcategoryId;
  final String? selectedId;
  final ValueChanged<CatalogCategory> onCategoryTap;
  final ValueChanged<String> onSubcategoryTap;
  final ValueChanged<CatalogMaterial> onMaterialTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slivers = <Widget>[];

    for (final category in categories) {
      final categoryOpen = expandedCategoryId == category.id;
      final materialCount = category.subcategories.fold<int>(
        0,
        (sum, s) => sum + s.materials.length,
      );

      final categoryRow = AppTreeRow.category(
        title: category.name,
        meta: categoryOpen
            ? l10n.pickCollapseMark
            : l10n.pickCategoryMeta(
                category.subcategories.length,
                materialCount,
              ),
        expanded: categoryOpen,
        onTap: () => onCategoryTap(category),
      );

      slivers.add(
        categoryOpen
            ? _pinned(categoryRow, AppDimens.rowHeightCategory)
            : _spaced(categoryRow),
      );
      if (!categoryOpen) continue;

      for (final subcategory in category.subcategories) {
        final subcategoryOpen = expandedSubcategoryId == subcategory.id;
        final subcategoryRow = AppTreeRow.subcategory(
          title: subcategory.name,
          meta: subcategoryOpen
              ? l10n.pickCollapseMark
              : l10n.pickMaterialsShort(subcategory.materials.length),
          expanded: subcategoryOpen,
          onTap: () => onSubcategoryTap(subcategory.id),
        );

        slivers.add(
          subcategoryOpen
              ? _pinned(subcategoryRow, AppDimens.rowHeightSubcategory)
              : _spaced(subcategoryRow),
        );
        if (!subcategoryOpen) continue;

        slivers.add(
          SliverList.separated(
            itemCount: subcategory.materials.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimens.space6),
            itemBuilder: (context, index) {
              final material = subcategory.materials[index];
              return AppTreeRow.material(
                title: material.name,
                meta: materialUnitLabel(l10n, material.unit),
                selected: selectedId == material.id,
                onTap: () => onMaterialTap(material),
              );
            },
          ),
        );
        slivers.add(
          const SliverToBoxAdapter(child: SizedBox(height: AppDimens.space6)),
        );
      }
    }

    return SliverMainAxisGroup(slivers: slivers);
  }

  Widget _spaced(Widget row) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space6),
      child: row,
    ),
  );

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
