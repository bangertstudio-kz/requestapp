// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$requestsRoute, $catalogRoute];

RouteBase get $requestsRoute => GoRouteData.$route(
  path: '/requests',
  hasOverriddenOnExit: false,
  factory: $RequestsRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'new-folder',
      hasOverriddenOnExit: false,
      factory: $NewFolderRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'folder/:folderId',
      hasOverriddenOnExit: false,
      factory: $FolderRequestsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'detail/:requestId',
      hasOverriddenOnExit: false,
      factory: $RequestDetailRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'pick',
          hasOverriddenOnExit: false,
          factory: $PickMaterialRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'item/:itemId',
          hasOverriddenOnExit: false,
          factory: $RequestItemRoute._fromState,
        ),
      ],
    ),
  ],
);

mixin $RequestsRoute on GoRouteData {
  static RequestsRoute _fromState(GoRouterState state) => const RequestsRoute();

  @override
  String get location => GoRouteData.$location('/requests');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NewFolderRoute on GoRouteData {
  static NewFolderRoute _fromState(GoRouterState state) =>
      const NewFolderRoute();

  @override
  String get location => GoRouteData.$location('/requests/new-folder');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FolderRequestsRoute on GoRouteData {
  static FolderRequestsRoute _fromState(GoRouterState state) =>
      FolderRequestsRoute(folderId: state.pathParameters['folderId']!);

  FolderRequestsRoute get _self => this as FolderRequestsRoute;

  @override
  String get location => GoRouteData.$location(
    '/requests/folder/${Uri.encodeComponent(_self.folderId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RequestDetailRoute on GoRouteData {
  static RequestDetailRoute _fromState(GoRouterState state) =>
      RequestDetailRoute(
        requestId: state.pathParameters['requestId']!,
        $extra: state.extra as MaterialRequest?,
      );

  RequestDetailRoute get _self => this as RequestDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/requests/detail/${Uri.encodeComponent(_self.requestId)}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $PickMaterialRoute on GoRouteData {
  static PickMaterialRoute _fromState(GoRouterState state) => PickMaterialRoute(
    requestId: state.pathParameters['requestId']!,
    replaceItemId: state.uri.queryParameters['replace-item-id'],
  );

  PickMaterialRoute get _self => this as PickMaterialRoute;

  @override
  String get location => GoRouteData.$location(
    '/requests/detail/${Uri.encodeComponent(_self.requestId)}/pick',
    queryParams: {
      if (_self.replaceItemId != null) 'replace-item-id': _self.replaceItemId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RequestItemRoute on GoRouteData {
  static RequestItemRoute _fromState(GoRouterState state) => RequestItemRoute(
    requestId: state.pathParameters['requestId']!,
    itemId: state.pathParameters['itemId']!,
  );

  RequestItemRoute get _self => this as RequestItemRoute;

  @override
  String get location => GoRouteData.$location(
    '/requests/detail/${Uri.encodeComponent(_self.requestId)}/item/${Uri.encodeComponent(_self.itemId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $catalogRoute => GoRouteData.$route(
  path: '/catalog',
  hasOverriddenOnExit: false,
  factory: $CatalogRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'import',
      hasOverriddenOnExit: false,
      factory: $CatalogImportRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'category-form',
      hasOverriddenOnExit: false,
      factory: $CategoryFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'subcategory-form',
      hasOverriddenOnExit: false,
      factory: $SubcategoryFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'material-form',
      hasOverriddenOnExit: false,
      factory: $MaterialFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'category/:categoryId',
      hasOverriddenOnExit: false,
      factory: $CategoryRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'subcategory/:subcategoryId',
          hasOverriddenOnExit: false,
          factory: $SubcategoryRoute._fromState,
        ),
      ],
    ),
  ],
);

mixin $CatalogRoute on GoRouteData {
  static CatalogRoute _fromState(GoRouterState state) => const CatalogRoute();

  @override
  String get location => GoRouteData.$location('/catalog');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CatalogImportRoute on GoRouteData {
  static CatalogImportRoute _fromState(GoRouterState state) =>
      const CatalogImportRoute();

  @override
  String get location => GoRouteData.$location('/catalog/import');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CategoryFormRoute on GoRouteData {
  static CategoryFormRoute _fromState(GoRouterState state) =>
      CategoryFormRoute(categoryId: state.uri.queryParameters['category-id']);

  CategoryFormRoute get _self => this as CategoryFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/category-form',
    queryParams: {
      if (_self.categoryId != null) 'category-id': _self.categoryId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SubcategoryFormRoute on GoRouteData {
  static SubcategoryFormRoute _fromState(GoRouterState state) =>
      SubcategoryFormRoute(
        categoryId: state.uri.queryParameters['category-id']!,
        subcategoryId: state.uri.queryParameters['subcategory-id'],
      );

  SubcategoryFormRoute get _self => this as SubcategoryFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/subcategory-form',
    queryParams: {
      'category-id': _self.categoryId,
      if (_self.subcategoryId != null) 'subcategory-id': _self.subcategoryId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MaterialFormRoute on GoRouteData {
  static MaterialFormRoute _fromState(GoRouterState state) => MaterialFormRoute(
    materialId: state.uri.queryParameters['material-id'],
    categoryId: state.uri.queryParameters['category-id'],
    subcategoryId: state.uri.queryParameters['subcategory-id'],
  );

  MaterialFormRoute get _self => this as MaterialFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/material-form',
    queryParams: {
      if (_self.materialId != null) 'material-id': _self.materialId,
      if (_self.categoryId != null) 'category-id': _self.categoryId,
      if (_self.subcategoryId != null) 'subcategory-id': _self.subcategoryId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CategoryRoute on GoRouteData {
  static CategoryRoute _fromState(GoRouterState state) =>
      CategoryRoute(categoryId: state.pathParameters['categoryId']!);

  CategoryRoute get _self => this as CategoryRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/category/${Uri.encodeComponent(_self.categoryId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SubcategoryRoute on GoRouteData {
  static SubcategoryRoute _fromState(GoRouterState state) => SubcategoryRoute(
    categoryId: state.pathParameters['categoryId']!,
    subcategoryId: state.pathParameters['subcategoryId']!,
  );

  SubcategoryRoute get _self => this as SubcategoryRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/category/${Uri.encodeComponent(_self.categoryId)}/subcategory/${Uri.encodeComponent(_self.subcategoryId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
