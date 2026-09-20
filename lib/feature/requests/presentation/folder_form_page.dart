import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/widgets/name_form_screen.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/requests_params.dart';
import 'create_folder_notifier.dart';

/// Создание папки для заявок.
class FolderFormPage extends StatefulWidget {
  const FolderFormPage({super.key});

  @override
  State<FolderFormPage> createState() => _FolderFormPageState();
}

class _FolderFormPageState extends State<FolderFormPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Валидация — через Form: ошибка пустого названия принадлежит полю,
    // а не флагу «показать ошибку» в состоянии экрана.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<CreateFolderNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final created = await notifier.run(
      CreateFolderParams(_controller.text.trim()),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    snack.show(failure ?? l10n.snackFolderCreated);
    // Возвращаем идентификатор: тот, кто завёл папку из шторки переноса,
    // ждёт её, а не «форма закрылась». Остальные вызывающие результат
    // игнорируют, и для них ничего не меняется.
    if (failure == null) Navigator.of(context).pop(created?.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return NameFormScreen(
      title: l10n.formTitleFolder,
      editing: false,
      controller: _controller,
      formKey: _formKey,
      onSave: _save,
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
