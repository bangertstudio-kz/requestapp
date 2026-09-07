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
import '../domain/entities/catalog_material.dart';
import '../domain/entities/catalog_search_params.dart';
import 'catalog_notifier.dart';
import 'material_pick_screen.dart';
import 'material_search_notifier.dart';
import 'material_unit_label.dart';
import 'quantity_controller.dart';

/// Подбор материала для заявки.
///
/// [replaceItemId] не `null` — материал не добавляют, а заменяют в уже
/// существующей позиции: тот же экран, другой глагол на выходе.
class MaterialPickPage extends StatefulWidget {
  const MaterialPickPage({
    super.key,
    required this.requestId,
    this.replaceItemId,
  });

  final String requestId;
  final String? replaceItemId;

  @override
  State<MaterialPickPage> createState() => _MaterialPickPageState();
}

class _MaterialPickPageState extends State<MaterialPickPage> {
  final _searchController = TextEditingController();
  final _quantity = QuantityController();
  final _debouncer = Debouncer();

  CatalogMaterial? _selected;

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
  void didUpdateWidget(covariant MaterialPickPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestId == widget.requestId &&
        oldWidget.replaceItemId == widget.replaceItemId) {
      return;
    }
    // Другая заявка — другой выбор и другое количество.
    _selected = null;
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
      NotifierScope.read<MaterialSearchNotifier>(
        context,
      ).request(CatalogSearchParams(_query));
    });
  }

  void _select(CatalogMaterial material) => setState(() {
    _selected = material;
    _quantity.value = '';
  });

  void _clearSelection() => setState(() {
    _selected = null;
    _quantity.value = '';
  });

  Future<void> _add(
    MaterialRequest request,
    CatalogMaterial material,
    int quantity,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = NotifierScope.read<UpdateRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final unit = materialUnitLabel(l10n, material.unit);

    final replaceId = widget.replaceItemId;
    final updated = replaceId == null
        ? request.withItems([
            ...request.items,
            RequestItem(
              // Идентификатор позиции свой, не материала: один и тот же
              // материал можно добавить дважды — например, на два стояка.
              id: '${request.id}-${DateTime.now().microsecondsSinceEpoch}',
              name: material.name,
              categoryName: material.categoryName,
              subcategoryName: material.subcategoryName,
              quantity: quantity,
              unit: material.unit,
            ),
          ])
        : request.replacingItem(
            RequestItem(
              id: replaceId,
              name: material.name,
              categoryName: material.categoryName,
              subcategoryName: material.subcategoryName,
              quantity: quantity,
              unit: material.unit,
            ),
          );

    await notifier.run(UpdateRequestParams(updated));
    if (!mounted) return;

    final failure = notifier.failure;
    if (failure != null) {
      snack.show(failure);
      return;
    }
    snack.show(
      replaceId == null
          ? l10n.snackMaterialAdded(material.name, quantity, unit)
          : l10n.snackMaterialReplaced(material.name),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = NotifierScope.of<CatalogNotifier>(context);
    final search = NotifierScope.of<MaterialSearchNotifier>(context);
    final detail = NotifierScope.of<RequestDetailNotifier>(context);

    final loaded = detail.data;
    final request = (loaded != null && loaded.id == widget.requestId)
        ? loaded
        : null;

    return RequestView<List<CatalogCategory>>(
      state: catalog.value,
      onRetry: () => NotifierScope.read<CatalogNotifier>(context).request(null),
      placeholderTitle: AppLocalizations.of(context)!.pickTitle,
      onBack: () => Navigator.of(context).pop(),
      builder: (context, categories) => MaterialPickScreen(
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
        onAdd: (material, quantity) => request == null
            ? Future<void>.value()
            : _add(request, material, quantity),
        onBack: () => Navigator.of(context).pop(),
      ),
    );
  }
}
