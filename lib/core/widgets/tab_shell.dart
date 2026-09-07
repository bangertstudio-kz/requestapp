import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';
import '../navigation/app_routes.dart';
import 'window_shell.dart';

/// Оболочка вкладки: нижняя панель на телефоне, rail на широком окне.
///
/// Переключение вкладки — `go`, а не `push`: в прототипе оно сбрасывает
/// историю, и возвращаться «назад» из справочника в середину стека заявок
/// было бы сюрпризом.
class TabShell extends StatelessWidget {
  const TabShell({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WindowShell(
      selectedIndex: index,
      onSelected: (value) => value == 0
          ? const RequestsRoute().go(context)
          : const CatalogRoute().go(context),
      destinations: [
        AppNavDestination(icon: Icons.list_alt, label: l10n.navRequests),
        AppNavDestination(icon: Icons.grid_view, label: l10n.navCatalog),
      ],
      child: child,
    );
  }
}
