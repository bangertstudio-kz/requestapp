import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../feature/catalog/presentation/catalog_import_page.dart';
import '../../feature/catalog/presentation/catalog_page.dart';
import '../../feature/catalog/presentation/category_form_page.dart';
import '../../feature/catalog/presentation/category_page.dart';
import '../../feature/catalog/presentation/material_form_page.dart';
import '../../feature/catalog/presentation/material_pick_page.dart';
import '../../feature/catalog/presentation/subcategory_form_page.dart';
import '../../feature/catalog/presentation/subcategory_page.dart';
import '../../feature/requests/domain/entities/material_request.dart';
import '../../feature/requests/presentation/folder_form_page.dart';
import '../../feature/requests/presentation/request_detail_page.dart';
import '../../feature/requests/presentation/request_item_page.dart';
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
        TypedGoRoute<PickMaterialRoute>(path: 'pick'),
        TypedGoRoute<RequestItemRoute>(path: 'item/:itemId'),
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
class PickMaterialRoute extends GoRouteData with $PickMaterialRoute {
  const PickMaterialRoute({required this.requestId, this.replaceItemId});

  final String requestId;

  /// Не `null` — материал не добавляют, а заменяют в существующей позиции.
  final String? replaceItemId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MaterialPickPage(requestId: requestId, replaceItemId: replaceItemId);
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
    TypedGoRoute<SubcategoryFormRoute>(path: 'subcategory-form'),
    TypedGoRoute<MaterialFormRoute>(path: 'material-form'),
    TypedGoRoute<CategoryRoute>(
      path: 'category/:categoryId',
      routes: [
        TypedGoRoute<SubcategoryRoute>(path: 'subcategory/:subcategoryId'),
      ],
    ),
  ],
)
class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CatalogPage();
}

class CatalogImportRoute extends GoRouteData with $CatalogImportRoute {
  const CatalogImportRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CatalogImportPage();
}

/// Форма категории. `categoryId == null` — создание.
class CategoryFormRoute extends GoRouteData with $CategoryFormRoute {
  const CategoryFormRoute({this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CategoryFormPage(categoryId: categoryId);
}

class SubcategoryFormRoute extends GoRouteData with $SubcategoryFormRoute {
  const SubcategoryFormRoute({required this.categoryId, this.subcategoryId});

  final String categoryId;
  final String? subcategoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SubcategoryFormPage(categoryId: categoryId, subcategoryId: subcategoryId);
}

/// Форма материала. Без `materialId` — создание; `categoryId`
/// и `subcategoryId` задают ветку, предвыбранную в форме.
class MaterialFormRoute extends GoRouteData with $MaterialFormRoute {
  const MaterialFormRoute({
    this.materialId,
    this.categoryId,
    this.subcategoryId,
  });

  final String? materialId;
  final String? categoryId;
  final String? subcategoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) => MaterialFormPage(
    materialId: materialId,
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

class SubcategoryRoute extends GoRouteData with $SubcategoryRoute {
  const SubcategoryRoute({
    required this.categoryId,
    required this.subcategoryId,
  });

  final String categoryId;
  final String subcategoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SubcategoryPage(categoryId: categoryId, subcategoryId: subcategoryId);
}
