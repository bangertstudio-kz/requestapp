import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

void main() => runApp(const GalleryApp());

/// Галерея дизайн-системы: все компоненты пакета в одном месте.
///
/// Живёт в `example/`, а не в приложении: компоненты должны собираться и
/// смотреться без фич, репозиториев и сети — иначе «посмотреть кнопку»
/// начинает требовать запущенный бэкенд.
class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'request_ui',
        debugShowCheckedModeBanner: false,
        theme: RequestTheme.light,
        home: const GalleryScreen(),
      );
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController(text: 'ЖК Северный, стояки Б2');

  int _navIndex = 0;
  int _filterIndex = 0;
  int _tabIndex = 0;
  int _choiceIndex = 1;
  int _unitIndex = 0;
  bool _categoryExpanded = true;
  bool _materialSelected = true;
  String _quantity = '24';

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onKey(AppKeypadKey key) => setState(() {
        switch (key) {
          case AppKeypadBackspace():
            if (_quantity.isNotEmpty) {
              _quantity = _quantity.substring(0, _quantity.length - 1);
            }
          case AppKeypadDigits(:final digits):
            if (_quantity.isEmpty && int.parse(digits) == 0) return;
            if (_quantity.length + digits.length > 6) return;
            _quantity += digits;
        }
      });

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Scaffold(
      backgroundColor: tokens.background,
      bottomNavigationBar: AppNavBar(
        destinations: const [
          AppNavDestination(icon: Icons.list_alt, label: 'Заявки'),
          AppNavDestination(icon: Icons.grid_view, label: 'Справочник'),
        ],
        selectedIndex: _navIndex,
        onSelected: (index) => setState(() => _navIndex = index),
      ),
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                AppDimens.space8,
                AppDimens.screenPadding,
                AppDimens.space26 * 2,
              ),
              children: [
                const AppTopBar(
                  title: 'Дизайн-система',
                  subtitle: 'Заявки на материалы · light',
                ),
                _Section(
                  title: 'Палитра',
                  child: Wrap(
                    spacing: AppDimens.space10,
                    runSpacing: AppDimens.space10,
                    children: [
                      _Swatch(color: tokens.primary, name: 'primary'),
                      _Swatch(color: tokens.primaryTint, name: 'primaryTint'),
                      _Swatch(
                        color: tokens.primarySelected,
                        name: 'primarySelected',
                      ),
                      _Swatch(color: tokens.surface, name: 'surface'),
                      _Swatch(color: tokens.background, name: 'background'),
                      _Swatch(color: tokens.border, name: 'border'),
                      _Swatch(color: tokens.ink, name: 'ink'),
                      _Swatch(color: tokens.inkMuted, name: 'inkMuted'),
                      _Swatch(color: tokens.danger, name: 'danger'),
                      _Swatch(color: tokens.success, name: 'success'),
                    ],
                  ),
                ),
                _Section(
                  title: 'Типографика',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Заявки на материалы',
                          style: tokens.text.appBarTitle),
                      Text('3 заявки', style: tokens.text.appBarSubtitle),
                      const SizedBox(height: AppDimens.space10),
                      Text('ЖК Северный, стояки Б2',
                          style: tokens.text.cardTitle),
                      Text('Труба ⌀100/2000', style: tokens.text.itemTitle),
                      Text('Канализация → Труба', style: tokens.text.caption),
                      const SizedBox(height: AppDimens.space10),
                      Text('04.09.2026 · 24 шт.', style: tokens.text.meta),
                      Text('128', style: tokens.text.quantityDisplay),
                    ],
                  ),
                ),
                _Section(
                  title: 'Кнопки',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton.filled(
                        label: 'Добавить материал',
                        icon: Icons.add,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppDimens.space10),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: AppButton.tonal(
                              label: 'Сохранить',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: AppDimens.space10),
                          Expanded(
                            flex: 5,
                            child: AppButton.dangerOutlined(
                              label: 'Удалить',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space10),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.outlined(
                              label: 'Отмена',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: AppDimens.space10),
                          Expanded(
                            child: AppButton.dangerFilled(
                              label: 'Удалить',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space10),
                      Wrap(
                        spacing: AppDimens.space8,
                        runSpacing: AppDimens.space8,
                        children: [
                          AppButton.outlinedAccent(
                            label: 'Заменить материал',
                            onPressed: () {},
                          ),
                          AppButton.text(
                            label: 'Папка',
                            icon: Icons.add,
                            onPressed: () {},
                          ),
                          AppButton.dangerText(
                            label: 'Удалить',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space10),
                      // Недоступная кнопка сохраняет форму и теряет цвет.
                      const AppButton.filled(
                        label: 'Добавить в заявку',
                        onPressed: null,
                      ),
                    ],
                  ),
                ),
                _Section(
                  title: 'Чипы',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: AppDimens.space8,
                        runSpacing: AppDimens.space8,
                        children: [
                          for (final (index, label) in const [
                            'Все',
                            'Черновики',
                            'Сохранённые',
                            'Отправленные',
                          ].indexed)
                            AppChip(
                              label: label,
                              selected: index == _filterIndex,
                              onTap: () => setState(() => _filterIndex = index),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space12),
                      Row(
                        children: [
                          for (final (index, label)
                              in const ['Категории', 'Материалы'].indexed) ...[
                            Expanded(
                              child: AppChip(
                                style: AppChipStyle.tab,
                                label: label,
                                selected: index == _tabIndex,
                                onTap: () => setState(() => _tabIndex = index),
                              ),
                            ),
                            if (index == 0)
                              const SizedBox(width: AppDimens.space8),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppDimens.space12),
                      Wrap(
                        spacing: AppDimens.space8,
                        runSpacing: AppDimens.space8,
                        children: [
                          for (final (index, label) in const [
                            'Канализация',
                            'ППР',
                            'Металлопластик',
                          ].indexed)
                            AppChip(
                              style: AppChipStyle.choice,
                              label: label,
                              selected: index == _choiceIndex,
                              onTap: () => setState(() => _choiceIndex = index),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.space12),
                      Row(
                        children: [
                          for (final (index, label)
                              in const ['шт.', 'м.п.', 'комплект'].indexed) ...[
                            Expanded(
                              child: AppChip(
                                style: AppChipStyle.unit,
                                label: label,
                                selected: index == _unitIndex,
                                onTap: () => setState(() => _unitIndex = index),
                              ),
                            ),
                            if (index != 2)
                              const SizedBox(width: AppDimens.space8),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                _Section(
                  title: 'Статусы и плашки',
                  child: Wrap(
                    spacing: AppDimens.space8,
                    runSpacing: AppDimens.space8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      AppStatusChip(
                        label: 'Черновик',
                        tone: AppStatusTone.neutral,
                      ),
                      AppStatusChip(
                        label: 'Сохранена',
                        tone: AppStatusTone.positive,
                      ),
                      AppStatusChip(
                        label: 'Отправлена',
                        tone: AppStatusTone.info,
                      ),
                      AppMetaBadge(label: 'шт.'),
                      AppMetaBadge(label: 'м.п.', selected: true),
                    ],
                  ),
                ),
                _Section(
                  title: 'Строки дерева',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTreeRow.category(
                        title: 'Канализация',
                        meta: _categoryExpanded ? '−' : '13 подкат.',
                        expanded: _categoryExpanded,
                        onTap: () => setState(
                          () => _categoryExpanded = !_categoryExpanded,
                        ),
                      ),
                      const SizedBox(height: AppDimens.space6),
                      if (_categoryExpanded) ...[
                        AppTreeRow.subcategory(
                          title: 'Труба',
                          meta: '−',
                          expanded: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: AppDimens.space6),
                        AppTreeRow.material(
                          title: 'Труба ⌀100/2000',
                          meta: 'шт.',
                          selected: _materialSelected,
                          onTap: () => setState(
                            () => _materialSelected = !_materialSelected,
                          ),
                        ),
                        const SizedBox(height: AppDimens.space6),
                        AppTreeRow.material(
                          title: 'Труба ⌀100/3000',
                          meta: 'шт.',
                          onTap: () {},
                        ),
                        const SizedBox(height: AppDimens.space6),
                        // Строка результата поиска: без отступа и с путём —
                        // в плоском списке одинаковых названий несколько.
                        AppTreeRow.material(
                          title: 'Труба ⌀25',
                          subtitle: 'ППР → Труба',
                          meta: 'м.п.',
                          nested: false,
                          onTap: () {},
                        ),
                      ],
                    ],
                  ),
                ),
                _Section(
                  title: 'Поля',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSearchField(
                        controller: _searchController,
                        hintText: 'Поиск по материалам',
                        clearSemanticLabel: 'Очистить поиск',
                      ),
                      const SizedBox(height: AppDimens.space12),
                      AppLabeledField(
                        label: 'Название заявки',
                        controller: _nameController,
                      ),
                    ],
                  ),
                ),
                _Section(
                  title: 'Количество',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppQuantityDisplay(
                        label: 'Количество',
                        hint: 'Единица из справочника',
                        value: _quantity.isEmpty ? '0' : _quantity,
                        unit: 'шт.',
                        empty: _quantity.isEmpty,
                      ),
                      const SizedBox(height: AppDimens.space12),
                      AppNumericKeypad(
                        onKey: _onKey,
                        backspaceSemanticLabel: 'Стереть',
                      ),
                    ],
                  ),
                ),
                _Section(
                  title: 'Шторка',
                  child: AppSheet(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Удалить заявку?', style: tokens.text.sheetTitle),
                        const SizedBox(height: AppDimens.space4),
                        Text(
                          'Заявка «ЖК Северный, стояки Б2» и все её 4 позиций '
                          'будут удалены с устройства.',
                          style: tokens.text.sheetSubtitle,
                        ),
                        const SizedBox(height: AppDimens.space16),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.outlined(
                                label: 'Отмена',
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: AppDimens.space10),
                            Expanded(
                              child: AppButton.dangerFilled(
                                label: 'Удалить',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _Section(
                  title: 'Пустое состояние, снек, FAB',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppEmptyState(
                        message: 'Ничего не найдено.\n'
                            'Измените запрос или фильтр.',
                      ),
                      const SizedBox(height: AppDimens.space12),
                      const AppSnack(
                        message: 'Труба ⌀100/2000 · 24 шт. — добавлено',
                      ),
                      const SizedBox(height: AppDimens.space12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppFab(
                          label: 'Создать заявку',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: AppDimens.space12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppScrollTopButton(
                          label: 'Наверх',
                          visible: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppDimens.space22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.space10),
              child: AppSectionLabel(title),
            ),
            child,
          ],
        ),
      );
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.name});

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimens.radiusButtonSmall),
              border: Border.all(color: tokens.border),
            ),
          ),
          const SizedBox(height: AppDimens.space4),
          Text(name, style: tokens.text.caption),
        ],
      ),
    );
  }
}
