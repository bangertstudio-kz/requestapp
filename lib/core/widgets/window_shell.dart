import 'package:flutter/material.dart';
import 'package:request_ui/request_ui.dart';

import '../presentation/app_breakpoints.dart';

/// Оболочка окна: нижняя панель на телефоне, боковой rail на широком окне.
///
/// Список разделов один на обе формы — иначе на планшете у приложения
/// оказывается другой набор вкладок, чем на телефоне, и это замечают не сразу.
class WindowShell extends StatelessWidget {
  const WindowShell({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppWidth.of(context) >= AppWidth.desktop;

    return Scaffold(
      body: isDesktop
          ? Row(
              children: [
                AppNavRail(
                  destinations: destinations,
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                ),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: isDesktop
          ? null
          : AppNavBar(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
    );
  }
}
