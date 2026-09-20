import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_params.dart';
import '../domain/entities/item_draft.dart';
import '../domain/entities/item_unit.dart';
import 'catalog_flatten.dart';
import 'catalog_notifier.dart';
import 'category_pick_sheet.dart';
import 'item_path_label.dart';
import 'item_form_screen.dart';
import 'save_item_notifier.dart';

/// Создание, переименование и перенос материала.
class ItemFormPage extends StatefulWidget {
  const ItemFormPage({
    super.key,
    this.itemId,
    this.categoryId,
    this.subcategoryId,
  });

  final String? itemId;

  /// Ветка, из которой открыли форму: подставляется в новой записи, чтобы
  /// «+ Материал» внутри подкатегории не заставлял выбирать её заново.
  final String? categoryId;
  final String? subcategoryId;

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _categoryId;
  ItemUnit? _unit;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    final categories = NotifierScope.read<CatalogNotifier>(context).data;
    if (categories == null || categories.isEmpty) return;

    final id = widget.itemId;
    if (id != null) {
      // Правка: ищем, в какой ветке материал лежит сейчас — на любой
      // глубине, потому что глубина больше не ограничена.
      for (final category in flattenCategories(categories)) {
        final item = category.items.where((m) => m.id == id).firstOrNull;
        if (item == null) continue;
        _nameController.text = item.name;
        _categoryId = category.id;
        _unit = item.unit;
        _seeded = true;
        return;
      }
      return;
    }

    _categoryId = widget.categoryId;
    _unit = ItemUnit.piece;
    _seeded = true;
  }

  @override
  void didUpdateWidget(covariant ItemFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId == widget.itemId &&
        oldWidget.categoryId == widget.categoryId) {
      return;
    }
    // Форму переиспользовали под другую запись — засев надо повторить,
    // иначе в полях останется предыдущая.
    _seeded = false;
    didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final snack = NotifierScope.read<SnackNotifier>(context);
    final categoryId = _categoryId;
    if (categoryId == null) {
      // Справочник может быть пуст: сразу после установки категорий нет,
      // и материалу некуда лечь.
      snack.show(l10n.formCategoryRequired);
      return;
    }

    final notifier = NotifierScope.read<SaveItemNotifier>(context);
    await notifier.run(
      SaveItemParams(
        ItemDraft(
          id: widget.itemId,
          name: _nameController.text.trim(),
          categoryId: categoryId,
          unit: _unit ?? ItemUnit.piece,
        ),
      ),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackMaterialSaved);
    if (failure == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = NotifierScope.of<CatalogNotifier>(context);

    return RequestView<List<CatalogCategory>>(
      state: notifier.value,
      onRetry: () => NotifierScope.read<CatalogNotifier>(context).request(null),
      placeholderTitle: AppLocalizations.of(context)!.formTitleMaterial,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, categories) {
        final l10n = AppLocalizations.of(context)!;
        final options = [
          for (final category in flattenCategories(categories))
            (category: category, path: _pathOf(categories, category)),
        ];
        final selected = options
            .where((option) => option.category.id == _categoryId)
            .firstOrNull;

        return ItemFormScreen(
          editing: widget.itemId != null,
          categoryLabel: selected == null
              ? l10n.formParentEmpty
              : itemPathLabel(l10n, selected.path),
          selectedUnit: _unit ?? ItemUnit.piece,
          nameController: _nameController,
          formKey: _formKey,
          onCategoryTap: () async {
            final picked = await CategoryPickSheet.show(
              context,
              options: options,
              selectedId: _categoryId,
            );
            if (picked == null || !mounted) return;
            setState(() => _categoryId = picked);
          },
          onUnitSelected: (value) => setState(() => _unit = value),
          onSave: _save,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

/// Путь категории для подписи в форме.
List<String> _pathOf(List<CatalogCategory> categories, CatalogCategory target) {
  final byId = {for (final item in flattenCategories(categories)) item.id: item};
  final names = <String>[];
  final seen = <String>{};
  CatalogCategory? cursor = target;
  while (cursor != null && seen.add(cursor.id)) {
    names.insert(0, cursor.name);
    final parentId = cursor.parentId;
    cursor = parentId == null ? null : byId[parentId];
  }
  return names;
}
