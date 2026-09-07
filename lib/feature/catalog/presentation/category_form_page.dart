import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/name_form_screen.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/catalog_params.dart';
import 'catalog_notifier.dart';
import 'save_category_notifier.dart';

/// Создание и переименование категории.
class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Засев в didChangeDependencies, а не в build: справочник приезжает
    // асинхронно, а трогать контроллер во время построения кадра нельзя.
    if (_seeded || widget.categoryId == null) return;
    final categories = NotifierScope.read<CatalogNotifier>(context).data;
    final category = categories
        ?.where((item) => item.id == widget.categoryId)
        .firstOrNull;
    if (category == null) return;
    _controller.text = category.name;
    _seeded = true;
  }

  @override
  void didUpdateWidget(covariant CategoryFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId == widget.categoryId) {
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
    final notifier = NotifierScope.read<SaveCategoryNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    await notifier.run(
      SaveCategoryParams(id: widget.categoryId, name: _controller.text.trim()),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackCategorySaved);
    if (failure == null) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Подписка на справочник нужна ради засева: без неё
    // didChangeDependencies не вызовут, когда категории догрузятся.
    NotifierScope.of<CatalogNotifier>(context);

    return NameFormScreen(
      title: l10n.formTitleCategory,
      editing: widget.categoryId != null,
      controller: _controller,
      formKey: _formKey,
      onSave: _save,
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
