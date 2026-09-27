import 'package:flutter/material.dart';

import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/request_view.dart';
import '../../../generated/app_localizations.dart';
import '../../requests/domain/entities/material_request.dart';
import '../../requests/domain/entities/request_item.dart';
import '../../requests/domain/entities/requests_params.dart';
import '../../requests/presentation/request_detail_notifier.dart';
import '../../requests/presentation/update_request_notifier.dart';
import '../domain/entities/catalog_category.dart';
import '../domain/entities/catalog_item.dart';
import '../domain/entities/catalog_search_params.dart';
import 'catalog_notifier.dart';
import 'duplicate_item_sheet.dart';
import 'item_pick_screen.dart';
import 'item_search_notifier.dart';
import 'item_unit_label.dart';
import 'quantity_controller.dart';

/// Подбор материала для заявки.
///
/// [replaceItemId] не `null` — материал не добавляют, а заменяют в уже
/// существующей позиции: тот же экран, другой глагол на выходе.
class ItemPickPage extends StatefulWidget {
  const ItemPickPage({
    super.key,
    required this.requestId,
    this.replaceItemId,
  });

  final String requestId;
  final String? replaceItemId;

  @override
  State<ItemPickPage> createState() => _ItemPickPageState();
}

class _ItemPickPageState extends State<ItemPickPage> {
  final _searchController = TextEditingController();
  final _quantity = QuantityController();
  final _debouncer = Debouncer();

  CatalogItem? _selected;

  /// Заявка после последнего добавления.
  ///
  /// Экран не закрывается после добавления, а нотифаер детали сам не
  /// перечитывается: без этого поля второе добавление собиралось бы из
  /// заявки без первого — и молча его затирало.
  MaterialRequest? _saved;

  /// Пустая строка — поиска нет и рисуется дерево. Отдельное поле, потому что
  /// результат прошлого поиска живёт в нотифаере и после очистки строки
  /// подменил бы дерево собой.
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NotifierScope.read<CatalogNotifier>(context).request(null);
      NotifierScope.read<RequestDetailNotifier>(
        context,
      ).request(RequestParams(widget.requestId));
    });
  }

  @override
  void didUpdateWidget(covariant ItemPickPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId == widget.requestId &&
        oldWidget.replaceItemId == widget.replaceItemId) {
      return;
    }
    // Другая заявка — другой выбор и другое количество.
    _selected = null;
    _saved = null;
    _quantity.value = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NotifierScope.read<RequestDetailNotifier>(
        context,
      ).request(RequestParams(widget.requestId));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantity.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value.trim());
    _debouncer.run(() {
      if (!mounted || _query.isEmpty) return;
      NotifierScope.read<ItemSearchNotifier>(
        context,
      ).request(CatalogSearchParams(_query));
    });
  }

  void _select(CatalogItem item) => setState(() {
    _selected = item;
    _quantity.value = '';
  });

  void _clearSelection() => setState(() {
    _selected = null;
    _quantity.value = '';
  });

  Future<void> _add(
    MaterialRequest request,
    CatalogItem item,
    int quantity,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<UpdateRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final unit = itemUnitLabel(l10n, item.unit);

    final replaceId = widget.replaceItemId;

    // Материал уже в заявке — вторую позицию не заводим, а спрашиваем,
    // что сделать с количеством. Только при добавлении: замена работает
    // с одной конкретной позицией, и её место человек уже выбрал.
    final existing = replaceId == null
        ? request.items.where((i) => i.itemId == item.id).firstOrNull
        : null;
    int? merged;
    if (existing != null) {
      final choice = await DuplicateItemSheet.show(
        context,
        name: item.name,
        unit: unit,
        current: existing.quantity,
        quantity: quantity,
      );
      // Отмена оставляет шторку количества открытой: число можно поправить.
      if (choice == null || !mounted) return;
      merged = switch (choice) {
        DuplicateChoice.add => existing.quantity + quantity,
        DuplicateChoice.replace => quantity,
      };
    }

    final MaterialRequest updated;
    if (existing != null && merged != null) {
      updated = request.replacingItem(
        RequestItem(
          id: existing.id,
          itemId: existing.itemId,
          name: existing.name,
          path: existing.path,
          quantity: merged,
          unit: existing.unit,
        ),
      );
    } else if (replaceId == null) {
      updated = request.withItems([
        ...request.items,
        RequestItem(
          // Идентификатор позиции свой, не материала: позиция живёт и
          // тогда, когда материал удалили из справочника.
          id: '${request.id}-${DateTime.now().microsecondsSinceEpoch}',
          itemId: item.id,
          name: item.name,
          path: item.path,
          quantity: quantity,
          unit: item.unit,
        ),
      ]);
    } else {
      updated = request.replacingItem(
        RequestItem(
          id: replaceId,
          itemId: item.id,
          name: item.name,
          path: item.path,
          quantity: quantity,
          unit: item.unit,
        ),
      );
    }

    final saved = await notifier.run(UpdateRequestParams(updated));
    if (!mounted) return;

    if (saved == null) {
      final failure = notifier.failure;
      if (failure != null) snack.show(failure);
      return;
    }

    if (replaceId != null) {
      snack.show(l10n.snackMaterialReplaced(item.name));
      Navigator.of(context).pop();
      return;
    }
    // Добавление не закрывает экран: заявку набирают десятком позиций
    // подряд, и возвращаться в подбор после каждой — лишний круг.
    // Закрывается только шторка количества.
    snack.show(
      merged == null
          ? l10n.snackMaterialAdded(item.name, quantity, unit)
          : l10n.snackMaterialQuantityUpdated(item.name, merged, unit),
    );
    setState(() {
      _saved = saved;
      _selected = null;
      _quantity.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = NotifierScope.of<CatalogNotifier>(context);
    final search = NotifierScope.of<ItemSearchNotifier>(context);
    final detail = NotifierScope.of<RequestDetailNotifier>(context);

    final loaded = _saved ?? detail.data;
    final request = (loaded != null && loaded.id == widget.requestId)
        ? loaded
        : null;

    return RequestView<List<CatalogCategory>>(
      state: catalog.value,
      onRetry: () => NotifierScope.read<CatalogNotifier>(context).request(null),
      placeholderTitle: AppLocalizations.of(context)!.pickTitle,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, categories) => ItemPickScreen(
        categories: categories,
        searchResults: _query.isEmpty ? null : (search.data ?? const []),
        // «Ничего не найдено» на экране, где поиск ещё в полёте, — ответ,
        // который экран не имеет права давать.
        searchLoading: _query.isNotEmpty && search.data == null,
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        selected: _selected,
        onSelected: _select,
        onSelectionCleared: _clearSelection,
        quantityController: _quantity,
        // Пока заявка не загрузилась, добавлять некуда: кнопка в шторке
        // всё равно ждёт количества, и гонки здесь не возникает.
        onAdd: (item, quantity) => request == null
            ? Future<void>.value()
            : _add(request, item, quantity),
        onBack: () => Navigator.of(context).pop(),
      ),
    );
  }
}
