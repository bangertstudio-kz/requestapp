import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../feature/catalog/presentation/catalog_import_page.dart';
import '../../feature/catalog/presentation/catalog_page.dart';
import '../../feature/catalog/presentation/category_form_page.dart';
import '../../feature/catalog/presentation/category_page.dart';
import '../../feature/catalog/presentation/item_form_page.dart';
import '../../feature/catalog/presentation/item_pick_page.dart';
import '../../feature/requests/domain/entities/material_request.dart';
import '../../feature/requests/domain/entities/send_format.dart';
import '../../feature/requests/presentation/folder_form_page.dart';
import '../../feature/requests/presentation/request_detail_page.dart';
import '../../feature/requests/presentation/request_item_page.dart';
import '../../feature/requests/presentation/request_preview_page.dart';
import '../../feature/requests/presentation/requests_page.dart';

part 'app_routes.g.dart';

/// Все маршруты приложения.
///
/// Вкладки — два независимых корня, а не общая оболочка со стеками:
/// переключение вкладки в прототипе сбрасывает историю, и держать ради
/// этого `StatefulShellRoute` значит хранить состояние, которое сразу
/// же выбрасывается.
@TypedGoRoute<RequestsRoute>(
  path: '/requests',
  routes: [
    TypedGoRoute<NewFolderRoute>(path: 'new-folder'),
    TypedGoRoute<FolderRequestsRoute>(path: 'folder/:folderId'),
    TypedGoRoute<RequestDetailRoute>(
      path: 'detail/:requestId',
      routes: [
        TypedGoRoute<PickItemRoute>(path: 'pick'),
        TypedGoRoute<RequestItemRoute>(path: 'item/:itemId'),
        TypedGoRoute<RequestPreviewRoute>(path: 'preview/:format'),
      ],
    ),
  ],
)
class RequestsRoute extends GoRouteData with $RequestsRoute {
  const RequestsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RequestsPage();
}

/// Список заявок внутри папки. Отдельный маршрут, а не query-параметр:
/// «назад» из папки должно возвращать в общий список, а не закрывать экран.
class FolderRequestsRoute extends GoRouteData with $FolderRequestsRoute {
  const FolderRequestsRoute({required this.folderId});

  final String folderId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RequestsPage(folderId: folderId);
}

class NewFolderRoute extends GoRouteData with $NewFolderRoute {
  const NewFolderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FolderFormPage();
}

/// Экран заявки.
///
/// Модель едет в `$extra` и потому необязательна, а идентификатор — в пути
/// и обязателен: пришли из списка — рисуем сразу, пришли по ссылке — экран
/// грузит заявку сам. Это то, что делает deep link рабочим без редиректов.
class RequestDetailRoute extends GoRouteData with $RequestDetailRoute {
  const RequestDetailRoute({required this.requestId, this.$extra});

  final String requestId;
  final MaterialRequest? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RequestDetailPage(requestId: requestId, request: $extra);
}

/// Подбор материала. Открывается из заявки, поэтому относительный:
/// `pop` возвращает в ту заявку, которая спросила.
class PickItemRoute extends GoRouteData with $PickItemRoute {
  const PickItemRoute({required this.requestId, this.replaceItemId});

  final String requestId;

  /// Не `null` — материал не добавляют, а заменяют в существующей позиции.
  final String? replaceItemId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ItemPickPage(requestId: requestId, replaceItemId: replaceItemId);
}

/// Предпросмотр файлов перед отправкой.
///
/// Формат в пути, а не в query: экрана без формата не существует, и
/// необязательный параметр, без которого экран не строится, — ложь
/// в сигнатуре.
class RequestPreviewRoute extends GoRouteData with $RequestPreviewRoute {
  const RequestPreviewRoute({required this.requestId, required this.format});

  final String requestId;
  final SendFormat format;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RequestPreviewPage(requestId: requestId, format: format);
}

class RequestItemRoute extends GoRouteData with $RequestItemRoute {
  const RequestItemRoute({required this.requestId, required this.itemId});

  final String requestId;
  final String itemId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RequestItemPage(requestId: requestId, itemId: itemId);
}

@TypedGoRoute<CatalogRoute>(
  path: '/catalog',
  routes: [
    TypedGoRoute<CatalogImportRoute>(path: 'import'),
    TypedGoRoute<CategoryFormRoute>(path: 'category-form'),
    TypedGoRoute<ItemFormRoute>(path: 'item-form'),
    TypedGoRoute<CategoryRoute>(
      path: 'category/:categoryId',
      // Вложенных маршрутов нет: категория открывает категорию тем же
      // маршрутом, сколько бы уровней ни завели.
    ),
  ],
)
class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CatalogPage();
}

/// Импорт материалов. `categoryId` — категория-приёмник, предложенная
/// по умолчанию: импорт открыли из неё, и спрашивать второй раз незачем.
class CatalogImportRoute extends GoRouteData with $CatalogImportRoute {
  const CatalogImportRoute({this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CatalogImportPage(categoryId: categoryId);
}

/// Форма категории. `categoryId == null` — создание, `parentId` — место,
/// предложенное по умолчанию: пришли из категории — предлагаем её.
class CategoryFormRoute extends GoRouteData with $CategoryFormRoute {
  const CategoryFormRoute({this.categoryId, this.parentId});

  final String? categoryId;
  final String? parentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CategoryFormPage(categoryId: categoryId, parentId: parentId);
}

/// Форма материала. Без `itemId` — создание; `categoryId`
/// и `subcategoryId` задают ветку, предвыбранную в форме.
class ItemFormRoute extends GoRouteData with $ItemFormRoute {
  const ItemFormRoute({
    this.itemId,
    this.categoryId,
    this.subcategoryId,
  });

  final String? itemId;
  final String? categoryId;
  final String? subcategoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ItemFormPage(
    itemId: itemId,
    categoryId: categoryId,
    subcategoryId: subcategoryId,
  );
}

class CategoryRoute extends GoRouteData with $CategoryRoute {
  const CategoryRoute({required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CategoryPage(categoryId: categoryId);
}
