import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_params.dart';
import '../domain/entities/material_draft.dart';
import '../domain/entities/material_unit.dart';
import 'catalog_notifier.dart';
import 'material_form_screen.dart';
import 'save_material_notifier.dart';

/// Создание, переименование и перенос материала.
class MaterialFormPage extends StatefulWidget {
  const MaterialFormPage({
    super.key,
    this.materialId,
    this.categoryId,
    this.subcategoryId,
  });

  final String? materialId;

  /// Ветка, из которой открыли форму: подставляется в новой записи, чтобы
  /// «+ Материал» внутри подкатегории не заставлял выбирать её заново.
  final String? categoryId;
  final String? subcategoryId;

  @override
  State<MaterialFormPage> createState() => _MaterialFormPageState();
}

class _MaterialFormPageState extends State<MaterialFormPage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _categoryId;
  String? _subcategoryId;
  MaterialUnit? _unit;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    final categories = NotifierScope.read<CatalogNotifier>(context).data;
    if (categories == null || categories.isEmpty) return;

    final id = widget.materialId;
    if (id != null) {
      // Правка: находим, в какой ветке материал лежит сейчас — форма
      // показывает его текущее место и позволяет перенести.
      for (final category in categories) {
        for (final subcategory in category.subcategories) {
          final material = subcategory.materials
              .where((m) => m.id == id)
              .firstOrNull;
          if (material == null) continue;
          _nameController.text = material.name;
          _categoryId = category.id;
          _subcategoryId = subcategory.id;
          _unit = material.unit;
          _seeded = true;
          return;
        }
      }
      return;
    }

    final category =
        categories.where((item) => item.id == widget.categoryId).firstOrNull ??
        categories.first;
    _categoryId = category.id;
    _subcategoryId =
        widget.subcategoryId ?? category.subcategories.firstOrNull?.id;
    _unit = MaterialUnit.piece;
    _seeded = true;
  }

  @override
  void didUpdateWidget(covariant MaterialFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.materialId == widget.materialId &&
        oldWidget.categoryId == widget.categoryId &&
        oldWidget.subcategoryId == widget.subcategoryId) {
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
    final subcategoryId = _subcategoryId;
    if (categoryId == null || subcategoryId == null) {
      // Подкатегории может не быть вовсе — в только что созданной категории.
      snack.show(l10n.formSubcategoryRequired);
      return;
    }

    final notifier = NotifierScope.read<SaveMaterialNotifier>(context);
    await notifier.run(
      SaveMaterialParams(
        MaterialDraft(
          id: widget.materialId,
          name: _nameController.text.trim(),
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          unit: _unit ?? MaterialUnit.piece,
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
        final category =
            categories.where((item) => item.id == _categoryId).firstOrNull ??
            categories.first;

        return MaterialFormScreen(
          editing: widget.materialId != null,
          categories: categories,
          selectedCategory: category,
          selectedSubcategoryId: _subcategoryId,
          selectedUnit: _unit ?? MaterialUnit.piece,
          nameController: _nameController,
          formKey: _formKey,
          onCategorySelected: (value) => setState(() {
            _categoryId = value.id;
            // Подкатегория из прежней категории здесь не существует —
            // выбираем первую доступную, а не оставляем висеть чужую.
            _subcategoryId = value.subcategories.firstOrNull?.id;
          }),
          onSubcategorySelected: (value) =>
              setState(() => _subcategoryId = value),
          onUnitSelected: (value) => setState(() => _unit = value),
          onSave: _save,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
