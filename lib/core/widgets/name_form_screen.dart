import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';
import '../presentation/content_column.dart';
import 'form_action_bar.dart';

/// Форма из одного поля: категория, подкатегория, папка.
///
/// Один экран на три сущности, а не три одинаковых: у них нет ничего своего,
/// кроме заголовка. Отдельные файлы-обёртки над этим экраном были бы теми
/// самыми прослойками, которые только пробрасывают вызов.
class NameFormScreen extends StatelessWidget {
  const NameFormScreen({
    super.key,
    required this.title,
    required this.editing,
    required this.controller,
    required this.formKey,
    required this.onSave,
    required this.onCancel,
    this.hintText,
  });

  final String title;

  /// Правка существующей записи или создание новой — от этого зависит только
  /// подзаголовок, но он единственное, что отличает два состояния экрана.
  final bool editing;

  final TextEditingController controller;

  /// Ключ формы принадлежит вызывающему: он же решает, сохранять ли, и
  /// переживает пересборку экрана.
  final GlobalKey<FormState> formKey;

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: FormActionBar(onCancel: onCancel, onSave: onSave),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: title,
                subtitle: editing
                    ? l10n.formSubtitleEdit
                    : l10n.formSubtitleNew,
                onBack: onCancel,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.screenPadding,
                      AppDimens.space6,
                      AppDimens.screenPadding,
                      AppDimens.space26,
                    ),
                    child: AppLabeledField(
                      label: l10n.formNameLabel,
                      controller: controller,
                      hintText: hintText,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? l10n.formNameRequired
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
