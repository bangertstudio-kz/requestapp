import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:request_ui/request_ui.dart';

import '../../generated/app_localizations.dart';
import 'app_routes.dart';
import 'navigator_keys.dart';

/// Сборка маршрутизатора.
abstract final class AppRouter {
  static GoRouter create() => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const RequestsRoute().location,
    routes: $appRoutes,
    errorBuilder: (context, state) => const _RouteNotFound(),
  );
}

/// Экран несуществующего адреса.
///
/// Отдельный, а не редирект на главную: молчаливый переброс скрывает, что
/// ссылка битая, и человек уходит уверенный, что открыл то, что просил.
class _RouteNotFound extends StatelessWidget {
  const _RouteNotFound();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.request;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.routeNotFound,
                  textAlign: TextAlign.center,
                  style: tokens.text.sheetSubtitle,
                ),
                const SizedBox(height: AppDimens.space16),
                AppButton.outlinedAccent(
                  label: l10n.routeNotFoundAction,
                  onPressed: () => const RequestsRoute().go(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
