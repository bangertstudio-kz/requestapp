import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../../generated/app_localizations.dart';
import '../domain/entities/request_folder.dart';

/// Что выбрали в шторке папок.
///
/// Свой тип, а не `String?`: `null` уже означает отмену, и «вне папок»
/// пришлось бы кодировать вторым признаком в сигнатуре. Запечатанный —
/// чтобы забытую ветку нашёл компилятор, а не читатель списка заявок.
sealed class FolderChoice {
  const FolderChoice();
}

class MoveToFolder extends FolderChoice {
  const MoveToFolder(this.id);

  final String id;
}

class MoveOutOfFolders extends FolderChoice {
  const MoveOutOfFolders();
}

/// Папки ещё нет — сначала её заводят на своём экране.
class CreateFolderFirst extends FolderChoice {
  const CreateFolderFirst();
}

/// Шторка выбора папки для заявки.
///
/// Шторка, а не экран: папок в работе единицы, и они помещаются целиком.
/// Текущая помечена и не нажимается — «перенести туда, где уже лежит»
/// не имеет результата, и предлагать его незачем.
class FolderPickSheet extends StatelessWidget {
  const FolderPickSheet({
    super.key,
    required this.folders,
    required this.currentFolderId,
    required this.onSelected,
    required this.onCancel,
  });

  final List<RequestFolder> folders;

  /// `null` — заявка сейчас вне папок.
  final String? currentFolderId;

  final ValueChanged<FolderChoice> onSelected;
  final VoidCallback onCancel;

  /// Показывает шторку и возвращает выбор или `null` при отмене.
  static Future<FolderChoice?> show(
    BuildContext context, {
    required List<RequestFolder> folders,
    required String? currentFolderId,
  }) => showModalBottomSheet<FolderChoice>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => FolderPickSheet(
      folders: folders,
      currentFolderId: currentFolderId,
      onSelected: (choice) => Navigator.of(context).pop(choice),
      onCancel: () => Navigator.of(context).pop(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    final currentName = folders
        .where((folder) => folder.id == currentFolderId)
        .map((folder) => folder.name)
        .firstOrNull;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.folderSheetTitle, style: tokens.text.sheetTitle),
          const SizedBox(height: AppDimens.space4),
          Text(
            l10n.folderSheetCurrent(currentName ?? l10n.folderOutside),
            style: tokens.text.sheetSubtitle,
          ),
          const SizedBox(height: AppDimens.space14),
          // Список прокручивается: папок может стать больше, чем помещается
          // в шторку, и тогда «Отмена» должна остаться на экране.
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final folder in folders)
                    _FolderRow(
                      name: folder.name,
                      meta: folder.id == currentFolderId
                          ? l10n.folderSheetHere
                          : '${folder.requestCount}',
                      current: folder.id == currentFolderId,
                      onTap: () => onSelected(MoveToFolder(folder.id)),
                    ),
                  _FolderRow(
                    name: l10n.folderOutside,
                    meta: currentFolderId == null ? l10n.folderSheetHere : '',
                    current: currentFolderId == null,
                    onTap: () => onSelected(const MoveOutOfFolders()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.outlined(
            label: l10n.folderNew,
            size: AppButtonSize.medium,
            onPressed: () => onSelected(const CreateFolderFirst()),
          ),
          const SizedBox(height: AppDimens.space10),
          AppButton.neutralText(label: l10n.actionCancel, onPressed: onCancel),
        ],
      ),
    );
  }
}

/// Строка папки. Текущая подсвечена и не нажимается.
class _FolderRow extends StatelessWidget {
  const _FolderRow({
    required this.name,
    required this.meta,
    required this.current,
    required this.onTap,
  });

  final String name;
  final String meta;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space8),
      child: Material(
        color: current ? tokens.primarySelected : tokens.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: InkWell(
          onTap: current ? null : onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: current ? tokens.borderSelectedSoft : tokens.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: tokens.text.rowTitle.copyWith(
                      color: current ? tokens.primary : tokens.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(width: AppDimens.space8),
                  Text(
                    meta,
                    style: tokens.text.meta.copyWith(
                      color: current ? tokens.primary : tokens.inkTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
