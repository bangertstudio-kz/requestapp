import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';
import 'app_meta_badge.dart';
import 'hover_builder.dart';

/// Строка дерева «категория → подкатегория → материал».
///
/// Дерево разворачивается на месте, а не уводит на отдельный экран: путь до
/// материала — три уровня, и три перехода туда-обратно ради одной трубы
/// стоят дороже, чем отступ слева.
class AppTreeRow extends StatelessWidget {
  const AppTreeRow._(
    this._level, {
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.onTap,
    required this.indent,
    required this.height,
    required this.expanded,
    required this.selected,
  });

  /// Верхний уровень. Раскрытая категория меняет и фон, и рамку: в списке из
  /// шести категорий одного признака мало, чтобы найти раскрытую взглядом.
  const AppTreeRow.category({
    Key? key,
    required String title,
    required String meta,
    required VoidCallback onTap,
    bool expanded = false,
  }) : this._(
          _TreeLevel.category,
          key: key,
          title: title,
          subtitle: null,
          meta: meta,
          onTap: onTap,
          indent: 0,
          height: AppDimens.rowHeightCategory,
          expanded: expanded,
          selected: false,
        );

  const AppTreeRow.subcategory({
    Key? key,
    required String title,
    required String meta,
    required VoidCallback onTap,
    bool expanded = false,
  }) : this._(
          _TreeLevel.subcategory,
          key: key,
          title: title,
          subtitle: null,
          meta: meta,
          onTap: onTap,
          indent: AppDimens.space14,
          height: AppDimens.rowHeightSubcategory,
          expanded: expanded,
          selected: false,
        );

  /// Лист дерева. В плоском результате поиска отступа нет: там иерархии
  /// не видно, и сдвиг вправо ничего бы не означал.
  const AppTreeRow.material({
    Key? key,
    required String title,
    required String meta,
    required VoidCallback onTap,
    String? subtitle,
    bool selected = false,
    bool nested = true,
  }) : this._(
          _TreeLevel.material,
          key: key,
          title: title,
          subtitle: subtitle,
          meta: meta,
          onTap: onTap,
          indent: nested ? 28 : 0,
          // Со вторым рядом строка выше: в плоском результате поиска путь
          // обязателен — «Труба ⌀25» есть и в ППР, и в металлопластике,
          // и без пути выбор между ними — угадывание.
          height: subtitle == null ? AppDimens.rowHeight : 62,
          expanded: false,
          selected: selected,
        );

  final String title;
  final String? subtitle;
  final String meta;
  final VoidCallback onTap;
  final double indent;
  final double height;
  final bool expanded;
  final bool selected;
  final _TreeLevel _level;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final radius = BorderRadius.circular(AppDimens.radiusControl);

    final background = switch (_level) {
      _TreeLevel.category =>
        expanded ? tokens.surfaceHover : tokens.surface,
      _TreeLevel.subcategory => tokens.surface,
      _TreeLevel.material =>
        selected ? tokens.primarySelected : tokens.surface,
    };
    final border = switch (_level) {
      _TreeLevel.category => expanded ? tokens.primary : tokens.border,
      _TreeLevel.subcategory =>
        expanded ? tokens.borderSelectedSoft : tokens.border,
      _TreeLevel.material => selected ? tokens.primary : tokens.hover,
    };
    final titleStyle = switch (_level) {
      _TreeLevel.category => tokens.text.treeCategoryTitle,
      _TreeLevel.subcategory => tokens.text.treeSubcategoryTitle,
      _TreeLevel.material => tokens.text.treeMaterialTitle,
    };

    return Padding(
      padding: EdgeInsetsDirectional.only(start: indent),
      child: HoverBuilder(
        builder: (context, hovered, _) => SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              borderRadius: radius,
              border: Border.all(
                color: hovered && !selected && !expanded
                    ? tokens.borderHover
                    : border,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle,
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tokens.text.caption,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.space12),
                      if (_level == _TreeLevel.material)
                        AppMetaBadge(label: meta, selected: selected)
                      else
                        Text(meta, style: tokens.text.meta),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _TreeLevel { category, subcategory, material }
