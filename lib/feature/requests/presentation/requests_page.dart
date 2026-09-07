import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/presentation/notifier_scope.dart';
import '../../../core/presentation/request_notifier.dart';
import '../../../core/presentation/snack_notifier.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/request_view.dart';
import '../../../core/widgets/tab_shell.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_folder.dart';
import '../domain/entities/request_list.dart';
import '../domain/entities/requests_params.dart';
import 'create_request_notifier.dart';
import 'folder_list_notifier.dart';
import 'request_list_notifier.dart';
import 'requests_screen.dart';

/// Список заявок: корневой или внутри папки.
///
/// Один экран на оба случая, потому что отличаются они одним параметром
/// запроса. Отдельный «экран папки» повторил бы поиск, фильтры и карточки
/// ради заголовка.
class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key, this.folderId});

  final String? folderId;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();

  late RequestsParams _params = RequestsParams(folderId: widget.folderId);

  @override
  void initState() {
    super.initState();
    // После кадра: `request` публикует `RequestLoading` синхронно, а build
    // не может пометить грязным уже построенного предка-`InheritedNotifier`.
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant RequestsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderId == widget.folderId) return;
    // Переход между корнем списка и папкой переиспользует State.
    _params = _params.copyWith(
      folderId: widget.folderId,
      resetFolder: widget.folderId == null,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _load() {
    if (!mounted) return;
    NotifierScope.read<RequestListNotifier>(context).request(_params);
    NotifierScope.read<FolderListNotifier>(context).request(null);
  }

  void _apply(RequestsParams params) {
    _params = params;
    _load();
  }

  Future<void> _openRequest(MaterialRequest request) async {
    await RequestDetailRoute(
      requestId: request.id,
      // Модель едет с собой: заявку только что показали в списке, и рисовать
      // спиннер вместо неё на переходе — терять уже известное.
      $extra: request,
    ).push<void>(context);
    _load();
  }

  Future<void> _create() async {
    final notifier = NotifierScope.read<CreateRequestNotifier>(context);
    final snack = NotifierScope.read<SnackNotifier>(context);
    final created = await notifier.run(
      CreateRequestParams(folderId: widget.folderId),
    );
    if (!mounted) return;
    final failure = notifier.failure;
    if (created == null) {
      if (failure != null) snack.show(failure);
      return;
    }
    await _openRequest(created);
  }

  Future<void> _createFolder() async {
    await const NewFolderRoute().push<void>(context);
    _load();
  }

  Future<void> _openFolder(RequestFolder folder) async {
    await FolderRequestsRoute(folderId: folder.id).push<void>(context);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = NotifierScope.of<RequestListNotifier>(context);
    final folders = NotifierScope.of<FolderListNotifier>(context);

    return TabShell(
      index: 0,
      child: RequestView<RequestList>(
        state: list.value,
        onRetry: _load,
        builder: (context, data) => RequestsScreen(
          requests: data.items,
          totalCount: data.total,
          folders: folders.data ?? const [],
          folder: _currentFolder(folders.data),
          filter: _params.filter,
          searchController: _searchController,
          onSearchChanged: (value) =>
              _debouncer.run(() => _apply(_params.copyWith(query: value))),
          onFilterSelected: (value) =>
              setState(() => _apply(_params.copyWith(filter: value))),
          onFolderOpened: _openFolder,
          onFolderCreate: _createFolder,
          onRequestOpened: _openRequest,
          onRequestCreate: _create,
          onBack: widget.folderId == null
              ? null
              : () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  /// Папка по идентификатору маршрута. `null` и в корне, и пока папки
  /// не загрузились — заголовок в обоих случаях общий.
  RequestFolder? _currentFolder(List<RequestFolder>? loaded) {
    final id = widget.folderId;
    if (id == null || loaded == null) return null;
    return loaded.where((folder) => folder.id == id).firstOrNull;
  }
}
