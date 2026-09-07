import 'package:flutter/widgets.dart';

/// Корневой навигатор. Нужен диалогам и шторкам, которые обязаны лежать
/// поверх всего, а не внутри текущей вкладки.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
