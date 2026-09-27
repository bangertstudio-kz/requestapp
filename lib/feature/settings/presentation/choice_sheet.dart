import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

/// Шторка выбора одного значения из короткого списка.
///
/// Выбор закрывает шторку сразу: подтверждать смену языка или темы нечем —
/// её видно мгновенно, и так же мгновенно её можно вернуть.
class ChoiceSheet<T> extends StatelessWidget {
  const ChoiceSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;

  /// Значение и его подпись, в том порядке, в каком их показывать.
  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Показывает шторку и возвращает выбранное или `null`, если её закрыли.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<(T, String)> options,
    required T selected,
  }) => showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => ChoiceSheet<T>(
      title: title,
      options: options,
      selected: selected,
      onSelected: (value) => Navigator.of(context).pop(value),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    // Подсветка нажатия — скруглённая плашка вокруг строки, а не рамка
    // впритык к тексту: у строк свой отступ, и заголовок выровнен по нему.
    const inset = EdgeInsets.symmetric(horizontal: AppDimens.space12);

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: inset,
            child: Text(title, style: tokens.text.sheetTitle),
          ),
          const SizedBox(height: AppDimens.space8),
          for (final (value, label) in options)
            Semantics(
              selected: value == selected,
              inMutuallyExclusiveGroup: true,
              child: InkWell(
                onTap: () => onSelected(value),
                borderRadius: BorderRadius.circular(AppDimens.radiusControl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: inset,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(label, style: tokens.text.rowTitle),
                        ),
                        if (value == selected)
                          Icon(Icons.check, size: 20, color: tokens.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
