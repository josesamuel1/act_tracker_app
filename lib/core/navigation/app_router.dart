import 'package:act_tracker/core/navigation/guards/guards.dart';
import 'package:act_tracker/features/auth/presentation/pages/pages.dart';
import 'package:act_tracker/features/home/presentation/pages/pages.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(page: AuthRoute.page, path: '/auth'),
    CustomRoute(
      page: LayoutRoute.page,
      guards: [AuthGuard()],
      path: '/',
      initial: true,
      children: [CustomRoute(page: HomeRoute.page, path: 'home', initial: true)],
    ),
  ];
}
