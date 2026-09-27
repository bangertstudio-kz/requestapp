// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $requestsRoute,
  $catalogRoute,
  $settingsRoute,
];

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
          factory: $PickItemRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'item/:itemId',
          hasOverriddenOnExit: false,
          factory: $RequestItemRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'preview/:format',
          hasOverriddenOnExit: false,
          factory: $RequestPreviewRoute._fromState,
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

mixin $PickItemRoute on GoRouteData {
  static PickItemRoute _fromState(GoRouterState state) => PickItemRoute(
    requestId: state.pathParameters['requestId']!,
    replaceItemId: state.uri.queryParameters['replace-item-id'],
  );

  PickItemRoute get _self => this as PickItemRoute;

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

mixin $RequestPreviewRoute on GoRouteData {
  static RequestPreviewRoute _fromState(GoRouterState state) =>
      RequestPreviewRoute(
        requestId: state.pathParameters['requestId']!,
        format: _$SendFormatEnumMap._$fromName(
          state.pathParameters['format']!,
        )!,
      );

  RequestPreviewRoute get _self => this as RequestPreviewRoute;

  @override
  String get location => GoRouteData.$location(
    '/requests/detail/${Uri.encodeComponent(_self.requestId)}/preview/${Uri.encodeComponent(_$SendFormatEnumMap[_self.format]!)}',
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

const _$SendFormatEnumMap = {
  SendFormat.xlsx: 'xlsx',
  SendFormat.pdf: 'pdf',
  SendFormat.both: 'both',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
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
      path: 'item-form',
      hasOverriddenOnExit: false,
      factory: $ItemFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'category/:categoryId',
      hasOverriddenOnExit: false,
      factory: $CategoryRoute._fromState,
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
      CatalogImportRoute(categoryId: state.uri.queryParameters['category-id']);

  CatalogImportRoute get _self => this as CatalogImportRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/import',
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

mixin $CategoryFormRoute on GoRouteData {
  static CategoryFormRoute _fromState(GoRouterState state) => CategoryFormRoute(
    categoryId: state.uri.queryParameters['category-id'],
    parentId: state.uri.queryParameters['parent-id'],
  );

  CategoryFormRoute get _self => this as CategoryFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/category-form',
    queryParams: {
      if (_self.categoryId != null) 'category-id': _self.categoryId,
      if (_self.parentId != null) 'parent-id': _self.parentId,
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

mixin $ItemFormRoute on GoRouteData {
  static ItemFormRoute _fromState(GoRouterState state) => ItemFormRoute(
    itemId: state.uri.queryParameters['item-id'],
    categoryId: state.uri.queryParameters['category-id'],
    subcategoryId: state.uri.queryParameters['subcategory-id'],
  );

  ItemFormRoute get _self => this as ItemFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/item-form',
    queryParams: {
      if (_self.itemId != null) 'item-id': _self.itemId,
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

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $SettingsRoute._fromState,
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

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
