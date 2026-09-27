import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import 'core/dependencies/container/dependency_container.dart';
import 'core/dependencies/container/drift_dependency_factory.dart';
import 'core/dependencies/container/mock_dependency_factory.dart';
import 'core/env/env.dart';
import 'core/navigation/app_router.dart';
import 'core/presentation/multi_scope.dart';
import 'core/presentation/notifier_scope.dart';
import 'core/presentation/snack_notifier.dart';
import 'core/widgets/snack_overlay.dart';
import 'feature/catalog/data/catalog_repository.dart';
import 'feature/catalog/presentation/apply_import_notifier.dart';
import 'feature/catalog/presentation/catalog_notifier.dart';
import 'feature/catalog/presentation/delete_category_notifier.dart';
import 'feature/catalog/presentation/delete_item_notifier.dart';
import 'feature/catalog/presentation/export_catalog_notifier.dart';
import 'feature/catalog/presentation/item_search_notifier.dart';
import 'feature/catalog/presentation/parse_import_notifier.dart';
import 'feature/catalog/presentation/reorder_items_notifier.dart';
import 'feature/catalog/presentation/save_category_notifier.dart';
import 'feature/catalog/presentation/save_item_notifier.dart';
import 'feature/requests/data/request_repository.dart';
import 'feature/requests/presentation/create_folder_notifier.dart';
import 'feature/requests/presentation/create_request_notifier.dart';
import 'feature/requests/presentation/delete_request_notifier.dart';
import 'feature/requests/presentation/folder_list_notifier.dart';
import 'feature/requests/presentation/move_request_notifier.dart';
import 'feature/requests/presentation/prepare_documents_notifier.dart';
import 'feature/requests/presentation/request_detail_notifier.dart';
import 'feature/requests/presentation/request_list_notifier.dart';
import 'feature/requests/presentation/save_request_notifier.dart';
import 'feature/requests/presentation/send_request_notifier.dart';
import 'feature/requests/presentation/update_request_notifier.dart';
import 'feature/settings/domain/entities/app_language.dart';
import 'feature/settings/presentation/language_notifier.dart';
import 'generated/app_localizations.dart';

/// Единственное место сборки приложения.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Контейнер собирается до первого кадра: репозитории должны существовать
  // раньше, чем экран попробует что-то у них спросить. Фабрика на drift
  // успевает здесь же открыть базу и засеять пустое хранилище прайсом.
  //
  // Выбор фабрики — `const`, поэтому в сборку попадает только одна из них.
  const DependencyFactory factory = Env.useMocks
      ? MockRootFactory()
      : DriftRootFactory();
  final container = await factory.create();

  // Язык читается до первого кадра: иначе приложение на секунду открылось
  // бы по-русски и перерисовалось. Сбой чтения — не повод не запуститься:
  // остаётся русский, как до появления выбора.
  final language = await container.settingsRepository.language().catchError(
    (_) => null,
  );

  runApp(App(container: container, language: language ?? AppLanguage.ru));
}

/// Корень приложения: нотифаеры, скоупы и `MaterialApp.router`.
class App extends StatefulWidget {
  const App({
    super.key,
    required this.container,
    this.language = AppLanguage.ru,
  });

  final RootContainer container;

  /// Язык на старте. Дальше им владеет [LanguageNotifier].
  final AppLanguage language;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter.create();

  // Нотифаеры app-scoped: создаются здесь, раздаются через MultiScope,
  // экраны их не создают и не диспозят. Иначе возврат на экран заявки
  // после подбора материала начинался бы с пустого состояния.
  late final _snack = SnackNotifier();

  late final _requestList = RequestListNotifier(_requests);
  late final _requestDetail = RequestDetailNotifier(_requests);
  late final _createRequest = CreateRequestNotifier(_requests);
  late final _updateRequest = UpdateRequestNotifier(_requests);
  late final _deleteRequest = DeleteRequestNotifier(_requests);
  late final _moveRequest = MoveRequestNotifier(_requests);
  late final _saveRequest = SaveRequestNotifier(_requests);
  late final _sendRequest = SendRequestNotifier(_requests);
  late final _prepareDocuments = PrepareDocumentsNotifier(_requests);
  late final _folderList = FolderListNotifier(_requests);
  late final _createFolder = CreateFolderNotifier(_requests);

  late final _catalog = CatalogNotifier(_catalogRepository);
  late final _itemSearch = ItemSearchNotifier(_catalogRepository);
  late final _saveCategory = SaveCategoryNotifier(_catalogRepository);
  late final _deleteCategory = DeleteCategoryNotifier(_catalogRepository);
  late final _saveItem = SaveItemNotifier(_catalogRepository);
  late final _deleteItem = DeleteItemNotifier(_catalogRepository);
  late final _reorderItems = ReorderItemsNotifier(_catalogRepository);
  late final _exportCatalog = ExportCatalogNotifier(_catalogRepository);
  late final _parseImport = ParseImportNotifier(_catalogRepository);
  late final _applyImport = ApplyImportNotifier(_catalogRepository);

  // Сообщает язык и нотифаерам без BuildContext — `AppText` — ещё до того,
  // как хоть один из них упадёт и захочет объясниться.
  late final _language = LanguageNotifier(
    widget.container.settingsRepository,
    widget.language,
  );

  RequestRepository get _requests => widget.container.requestRepository;
  CatalogRepository get _catalogRepository =>
      widget.container.catalogRepository;

  @override
  void dispose() {
    _snack.dispose();
    _language.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiScope(
    // Первый в списке — самый внешний.
    wrappers: [
      (child) => NotifierScope<SnackNotifier>(controller: _snack, child: child),
      (child) => NotifierScope<LanguageNotifier>(
        controller: _language,
        child: child,
      ),
      (child) => NotifierScope<RequestListNotifier>(
        controller: _requestList,
        child: child,
      ),
      (child) => NotifierScope<RequestDetailNotifier>(
        controller: _requestDetail,
        child: child,
      ),
      (child) => NotifierScope<CreateRequestNotifier>(
        controller: _createRequest,
        child: child,
      ),
      (child) => NotifierScope<UpdateRequestNotifier>(
        controller: _updateRequest,
        child: child,
      ),
      (child) => NotifierScope<DeleteRequestNotifier>(
        controller: _deleteRequest,
        child: child,
      ),
      (child) => NotifierScope<MoveRequestNotifier>(
        controller: _moveRequest,
        child: child,
      ),
      (child) => NotifierScope<SaveRequestNotifier>(
        controller: _saveRequest,
        child: child,
      ),
      (child) => NotifierScope<SendRequestNotifier>(
        controller: _sendRequest,
        child: child,
      ),
      (child) => NotifierScope<PrepareDocumentsNotifier>(
        controller: _prepareDocuments,
        child: child,
      ),
      (child) => NotifierScope<FolderListNotifier>(
        controller: _folderList,
        child: child,
      ),
      (child) => NotifierScope<CreateFolderNotifier>(
        controller: _createFolder,
        child: child,
      ),
      (child) =>
          NotifierScope<CatalogNotifier>(controller: _catalog, child: child),
      (child) => NotifierScope<ItemSearchNotifier>(
        controller: _itemSearch,
        child: child,
      ),
      (child) => NotifierScope<SaveCategoryNotifier>(
        controller: _saveCategory,
        child: child,
      ),
      (child) => NotifierScope<DeleteCategoryNotifier>(
        controller: _deleteCategory,
        child: child,
      ),
      (child) => NotifierScope<SaveItemNotifier>(
        controller: _saveItem,
        child: child,
      ),
      (child) => NotifierScope<DeleteItemNotifier>(
        controller: _deleteItem,
        child: child,
      ),
      (child) => NotifierScope<ReorderItemsNotifier>(
        controller: _reorderItems,
        child: child,
      ),
      (child) => NotifierScope<ExportCatalogNotifier>(
        controller: _exportCatalog,
        child: child,
      ),
      (child) => NotifierScope<ParseImportNotifier>(
        controller: _parseImport,
        child: child,
      ),
      (child) => NotifierScope<ApplyImportNotifier>(
        controller: _applyImport,
        child: child,
      ),
    ],
    child: ValueListenableBuilder<AppLanguage>(
      valueListenable: _language,
      builder: (context, language, _) => _app(language.locale),
    ),
  );

  Widget _app(Locale locale) => MaterialApp.router(
    locale: locale,
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    debugShowCheckedModeBanner: false,
    theme: RequestTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: _router,
    // Снек навешивается поверх всей навигации: сообщение «Материал
    // добавлен» переживает возврат с экрана подбора на экран заявки.
    builder: (context, child) => ValueListenableBuilder<String?>(
      valueListenable: _snack,
      builder: (context, message, _) => SnackOverlay(
        message: message,
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  );
}
