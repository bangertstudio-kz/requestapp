import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../core/presentation/content_column.dart';
import '../../../generated/app_localizations.dart';
import '../domain/entities/material_request.dart';
import '../domain/entities/request_filter.dart';
import '../domain/entities/request_folder.dart';
import 'request_card.dart';

/// Список заявок: поиск, фильтр по статусу, папки и сами заявки.
///
/// Экран ничего не знает про источник данных: он получает уже отобранный
/// список и сообщает наверх о нажатиях. Отбор — работа нотифаера, потому что
/// на бэкенде он станет параметрами запроса, а не фильтрацией в памяти.
class RequestsScreen extends StatelessWidget {
  const RequestsScreen({
    super.key,
    required this.requests,
    required this.totalCount,
    required this.folders,
    required this.folder,
    required this.filter,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterSelected,
    required this.onFolderOpened,
    required this.onFolderCreate,
    required this.onRequestOpened,
    required this.onRequestCreate,
    this.onBack,
  });

  /// Заявки, прошедшие поиск и фильтр.
  final List<MaterialRequest> requests;

  /// Сколько заявок всего — подзаголовок считает их, а не видимые:
  /// «3 заявки» под фильтром «Черновики» не должно превращаться в «1 заявка».
  final int totalCount;

  final List<RequestFolder> folders;

  /// Открытая папка или `null` — корень списка.
  final RequestFolder? folder;

  final RequestFilter filter;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RequestFilter> onFilterSelected;
  final ValueChanged<RequestFolder> onFolderOpened;
  final VoidCallback onFolderCreate;
  final ValueChanged<MaterialRequest> onRequestOpened;
  final VoidCallback onRequestCreate;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentFolder = folder;
    // Папки показываются только в корне: внутри папки они были бы
    // предложением уйти оттуда, куда пользователь только что зашёл.
    final showFolders = currentFolder == null;
    // Заголовок вычисляется до дерева виджетов: выражение прямо в параметре
    // виджета анализатор разметки считает строкой, собранной в коде.
    final title = currentFolder?.name ?? l10n.requestsTitle;

    return Scaffold(
      floatingActionButton: AppFab(
        label: l10n.requestsCreate,
        onPressed: onRequestCreate,
      ),
      body: SafeArea(
        bottom: false,
        child: ContentColumn(
          child: Column(
            children: [
              AppTopBar(
                title: title,
                subtitle: l10n.requestsSubtitle(totalCount),
                onBack: onBack,
                backSemanticLabel: l10n.actionBack,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          0,
                          AppDimens.screenPadding,
                          AppDimens.space12,
                        ),
                        child: AppSearchField(
                          controller: searchController,
                          hintText: l10n.requestsSearchHint,
                          clearSemanticLabel: l10n.actionClearSearch,
                          onChanged: onSearchChanged,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _Filters(
                        selected: filter,
                        onSelected: onFilterSelected,
                      ),
                    ),
                    if (showFolders) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.labelPadding,
                            0,
                            AppDimens.space8,
                            AppDimens.space8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppSectionLabel(
                                  l10n.requestsFoldersLabel,
                                ),
                              ),
                              AppButton.text(
                                label: l10n.requestsFolderNew,
                                icon: Icons.add,
                                onPressed: onFolderCreate,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          0,
                          AppDimens.screenPadding,
                          AppDimens.space18,
                        ),
                        sliver: SliverList.separated(
                          itemCount: folders.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppDimens.space8),
                          itemBuilder: (context, index) {
                            final item = folders[index];
                            return _FolderCard(
                              folder: item,
                              onTap: () => onFolderOpened(item),
                            );
                          },
                        ),
                      ),
                    ],
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.labelPadding,
                          0,
                          AppDimens.labelPadding,
                          AppDimens.space8,
                        ),
                        child: AppSectionLabel(
                          showFolders
                              ? l10n.requestsListAll(requests.length)
                              : l10n.requestsListInFolder(requests.length),
                        ),
                      ),
                    ),
                    SliverPadding(
                      // Хвост под плавающей кнопкой: последняя карточка
                      // должна дотягиваться до края, а не прятаться под FAB.
                      padding: const EdgeInsets.fromLTRB(
                        AppDimens.screenPadding,
                        0,
                        AppDimens.screenPadding,
                        120,
                      ),
                      sliver: requests.isEmpty
                          ? SliverToBoxAdapter(
                              child: AppEmptyState(message: l10n.requestsEmpty),
                            )
                          : SliverList.separated(
                              itemCount: requests.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppDimens.space10),
                              itemBuilder: (context, index) {
                                final item = requests[index];
                                return RequestCard(
                                  request: item,
                                  onTap: () => onRequestOpened(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.selected, required this.onSelected});

  final RequestFilter selected;
  final ValueChanged<RequestFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.screenPadding,
        AppDimens.space2,
        AppDimens.screenPadding,
        AppDimens.space14,
      ),
      child: Row(
        children: [
          for (final value in RequestFilter.values) ...[
            AppChip(
              label: switch (value) {
                RequestFilter.all => l10n.requestsFilterAll,
                RequestFilter.drafts => l10n.requestsFilterDrafts,
                RequestFilter.saved => l10n.requestsFilterSaved,
                RequestFilter.sent => l10n.requestsFilterSent,
              },
              selected: value == selected,
              onTap: () => onSelected(value),
            ),
            if (value != RequestFilter.values.last)
              const SizedBox(width: AppDimens.space8),
          ],
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({required this.folder, required this.onTap});

  final RequestFolder folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return AppCard(
      onTap: onTap,
      minHeight: 58,
      borderRadius: AppDimens.radiusControl,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 20, color: tokens.inkSecondary),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Text(
              folder.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.text.itemTitle,
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Text(
            l10n.requestFolderCount(folder.requestCount),
            style: tokens.text.meta,
          ),
          const SizedBox(width: AppDimens.space8),
          Icon(Icons.chevron_right, size: 18, color: tokens.inkFaint),
        ],
      ),
    );
  }
}
