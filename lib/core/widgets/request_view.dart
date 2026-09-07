import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';
import '../presentation/content_column.dart';
import '../presentation/request_notifier.dart';

/// Рисует состояние запроса.
///
/// Правило «загрузка рисуется поверх старых данных» живёт здесь, в одном
/// месте. Двенадцать одинаковых `switch`-ей по экранам — это двенадцать
/// возможностей забыть ветку `RequestLoading(data: final data?)` и получить
/// мигание спиннером на каждом обновлении.
class RequestView<T> extends StatelessWidget {
  const RequestView({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
    this.placeholderTitle,
    this.onBack,
  });

  final RequestState<T> state;
  final Widget Function(BuildContext context, T data) builder;

  /// `null` — повторять нечего (например, операция была разовой).
  final VoidCallback? onRetry;

  /// Заголовок экрана-заглушки. Обязателен для страниц, которые сами не
  /// рисуют шапку до прихода данных: без него человек, пришедший по ссылке
  /// на упавший экран, остаётся на пустом белом листе без кнопки «назад».
  final String? placeholderTitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => switch (state) {
    RequestSuccess<T>(:final data) => builder(context, data),
    // Именно здесь: пока данные есть, экран продолжает их рисовать,
    // и обновление не подменяет ответ спиннером.
    RequestLoading<T>(data: final data?) => builder(context, data),
    RequestError<T>(:final message) => _Placeholder(
      title: placeholderTitle,
      onBack: onBack,
      child: _Failure(message: message, onRetry: onRetry),
    ),
    _ => _Placeholder(
      title: placeholderTitle,
      onBack: onBack,
      child: const _Loading(),
    ),
  };
}

/// Экран-заглушка на время загрузки и на случай ошибки.
///
/// Именно `Scaffold`, а не голый `Center`: он даёт и фон темы, и предка
/// `Material`. Без последнего Flutter рисует текст жёлтым подчёркиванием
/// «missing Material widget» — и это видно пользователю, а не только в отладке.
class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.child,
    required this.title,
    required this.onBack,
  });

  final Widget child;
  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;
    final heading = title;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              if (heading != null)
                AppTopBar(
                  title: heading,
                  onBack: onBack,
                  backSemanticLabel: l10n.actionBack,
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox.square(
      dimension: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        color: context.request.primary,
      ),
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: tokens.text.sheetSubtitle,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.space16),
              AppButton.outlinedAccent(
                label: l10n.actionRetry,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
