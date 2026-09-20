import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/name_form_screen.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_flatten.dart';
import 'catalog_notifier.dart';
import 'category_pick_sheet.dart';
import 'item_path_label.dart';
import 'save_category_notifier.dart';

/// Создание, переименование и переезд категории.
///
/// Одна форма на все уровни. Переключатель спрашивает не «что это», а «где
/// разместить»: с тех пор как вложенность не ограничена, а материалы лежат
/// в категории любого уровня, «родительская» и «подкатегория» отличаются
/// только этим.
class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key, this.categoryId, this.parentId});

  final String? categoryId;

  /// Откуда пришли: создание изнутри категории сразу предлагает её как место.
  final String? parentId;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String? _parentId = widget.parentId;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Засев в didChangeDependencies, а не в build: справочник приезжает
    // асинхронно, а трогать контроллер во время построения кадра нельзя.
    if (_seeded || widget.categoryId == null) return;
    final categories = NotifierScope.read<CatalogNotifier>(context).data;
    if (categories == null) return;
    final category = findCategory(categories, widget.categoryId!);
    if (category == null) return;
    _controller.text = category.name;
    _parentId = category.parentId;
    _seeded = true;
  }

  @override
  void didUpdateWidget(covariant CategoryFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId == widget.categoryId) return;
    // Форму переиспользовали под другую запись — засев надо повторить,
    // иначе в полях останется предыдущая.
    _seeded = false;
    _parentId = widget.parentId;
    didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Куда можно положить: все категории, кроме самой правимой и её потомков.
  /// Внутрь собственного потомка категория уйти не может — ветка пропала бы
  /// из дерева, оставшись в базе.
  List<({CatalogCategory category, List<String> path})> _options(
    List<CatalogCategory> categories,
  ) {
    final byId = {
      for (final item in flattenCategories(categories)) item.id: item,
    };

    bool isSelfOrDescendant(CatalogCategory candidate) {
      final id = widget.categoryId;
      if (id == null) return false;
      final seen = <String>{};
      CatalogCategory? cursor = candidate;
      while (cursor != null && seen.add(cursor.id)) {
        if (cursor.id == id) return true;
        final parentId = cursor.parentId;
        cursor = parentId == null ? null : byId[parentId];
      }
      return false;
    }

    List<String> pathOf(CatalogCategory category) {
      final names = <String>[];
      final seen = <String>{};
      CatalogCategory? cursor = category;
      while (cursor != null && seen.add(cursor.id)) {
        names.insert(0, cursor.name);
        final parentId = cursor.parentId;
        cursor = parentId == null ? null : byId[parentId];
      }
      return names;
    }

    return [
      for (final category in flattenCategories(categories))
        if (!isSelfOrDescendant(category))
          (category: category, path: pathOf(category)),
    ];
  }

  Future<void> _pickParent(List<CatalogCategory> categories) async {
    final picked = await CategoryPickSheet.show(
      context,
      options: _options(categories),
      selectedId: _parentId,
    );
    if (picked == null || !mounted) return;
    setState(() => _parentId = picked);
  }

  Future<void> _save() async {
    // Валидация — через Form: ошибка пустого названия принадлежит полю,
    // а не флагу «показать ошибку» в состоянии экрана.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<SaveCategoryNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(
      SaveCategoryParams(
        id: widget.categoryId,
        name: _controller.text.trim(),
        parentId: _parentId,
      ),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackCategorySaved);
    if (failure == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories =
        NotifierScope.of<CatalogNotifier>(context).data ??
        const <CatalogCategory>[];

    final parent = _parentId == null
        ? null
        : findCategory(categories, _parentId!);
    final parentLabel = parent == null
        ? l10n.formParentEmpty
        : itemPathLabel(
            l10n,
            _options(
              categories,
            ).where((option) => option.category.id == parent.id).map((option) => option.path).firstOrNull ??
                [parent.name],
          );

    return NameFormScreen(
      title: l10n.formTitleCategory,
      editing: widget.categoryId != null,
      controller: _controller,
      formKey: _formKey,
      onSave: _save,
      onCancel: () => Navigator.of(context).pop(),
      extra: [
        const SizedBox(height: AppDimens.space16),
        AppSectionLabel(l10n.formPlacementLabel),
        const SizedBox(height: AppDimens.space8),
        _Choice(
          label: l10n.formPlacementRoot,
          selected: _parentId == null,
          onTap: () => setState(() => _parentId = null),
        ),
        _Choice(
          label: l10n.formPlacementInside,
          selected: _parentId != null,
          // Выбор места и выбор самой категории — одно нажатие: отдельная
          // строка «теперь выберите родителя» была бы вторым шагом там,
          // где человек уже знает ответ.
          onTap: () => _pickParent(categories),
        ),
        if (_parentId != null) ...[
          const SizedBox(height: AppDimens.space10),
          _ParentRow(
            label: parentLabel,
            onTap: () => _pickParent(categories),
          ),
        ],
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Material(
        color: selected ? tokens.primarySelected : tokens.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: selected ? tokens.borderSelectedSoft : tokens.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: selected ? tokens.primary : tokens.inkTertiary,
                ),
                const SizedBox(width: AppDimens.space10),
                Expanded(
                  child: Text(
                    label,
                    style: tokens.text.rowTitle.copyWith(
                      color: selected ? tokens.primary : tokens.ink,
                    ),
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

class _ParentRow extends StatelessWidget {
  const _ParentRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Material(
      color: tokens.surfaceMuted,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space12,
            vertical: AppDimens.space10,
          ),
          child: Row(
            children: [
              Text(
                l10n.formParentLabel,
                style: tokens.text.meta.copyWith(color: tokens.inkTertiary),
              ),
              const SizedBox(width: AppDimens.space8),
              Expanded(
                child: Text(
                  label,
                  style: tokens.text.rowTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: tokens.inkTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
