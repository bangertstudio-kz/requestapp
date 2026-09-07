import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/name_form_screen.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_notifier.dart';
import 'save_subcategory_notifier.dart';

/// Создание и переименование подкатегории внутри категории.
class SubcategoryFormPage extends StatefulWidget {
  const SubcategoryFormPage({
    super.key,
    required this.categoryId,
    this.subcategoryId,
  });

  final String categoryId;
  final String? subcategoryId;

  @override
  State<SubcategoryFormPage> createState() => _SubcategoryFormPageState();
}

class _SubcategoryFormPageState extends State<SubcategoryFormPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded || widget.subcategoryId == null) return;
    final categories = NotifierScope.read<CatalogNotifier>(context).data;
    final subcategory = categories
        ?.where((item) => item.id == widget.categoryId)
        .firstOrNull
        ?.subcategories
        .where((item) => item.id == widget.subcategoryId)
        .firstOrNull;
    if (subcategory == null) return;
    _controller.text = subcategory.name;
    _seeded = true;
  }

  @override
  void didUpdateWidget(covariant SubcategoryFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId == widget.categoryId &&
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
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<SaveSubcategoryNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(
      SaveSubcategoryParams(
        id: widget.subcategoryId,
        categoryId: widget.categoryId,
        name: _controller.text.trim(),
      ),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackSubcategorySaved);
    if (failure == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    NotifierScope.of<CatalogNotifier>(context);

    return NameFormScreen(
      title: l10n.formTitleSubcategory,
      editing: widget.subcategoryId != null,
      controller: _controller,
      formKey: _formKey,
      onSave: _save,
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
