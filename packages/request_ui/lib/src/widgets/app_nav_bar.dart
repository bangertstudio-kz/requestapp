import 'package:flutter/material.dart';

import '../theme/request_tokens.dart';
import '../tokens/dimens.dart';

/// Пункт нижней панели или бокового rail'а.
@immutable
class AppNavDestination {
  const AppNavDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Нижняя панель навигации.
///
/// Выбранный пункт помечен пилюлей под иконкой, как в Material 3, но панель
/// своя: у макета нет ни разделителя-тени, ни индикатора во всю ширину.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space8,
            AppDimens.space8,
            AppDimens.space8,
            AppDimens.space10,
          ),
          child: Row(
            children: [
              for (final (index, destination) in destinations.indexed)
                Expanded(
                  child: _NavItem(
                    destination: destination,
                    selected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Боковой rail для широкого окна. Пункты те же — иначе на планшете и на
/// телефоне у приложения оказывается разный набор разделов.
class AppNavRail extends StatelessWidget {
  const AppNavRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;

    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(right: BorderSide(color: tokens.border)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const SizedBox(height: AppDimens.space16),
            for (final (index, destination) in destinations.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.space8),
                child: _NavItem(
                  destination: destination,
                  selected: index == selectedIndex,
                  onTap: () => onSelected(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.request;
    final foreground = selected ? tokens.primary : tokens.inkTertiary;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.space16 + AppDimens.space4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? tokens.primarySelected
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(destination.icon, size: 22, color: foreground),
              ),
              const SizedBox(height: AppDimens.space4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.navLabel.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
