import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'route_notifier.dart';

class AppRouteObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route.settings.name ?? '');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _updateRoute(previousRoute?.settings.name ?? '');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateRoute(newRoute?.settings.name ?? '');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _updateRoute(previousRoute?.settings.name ?? '');
  }

  void _updateRoute(String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RouteNotifier.currentRoute.value = routeName;
    });
  }
}

final appRouteObserver = AppRouteObserver();
