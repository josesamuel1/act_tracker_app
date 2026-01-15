import 'package:act_tracker/core/navigation/app_router.dart';
import 'package:act_tracker/features/home/presentation/strings/strings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppNavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final PageRouteInfo route;
  final String currentRoute;

  const AppNavBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.currentRoute,
    super.key,
  });

  bool _isActiveRoute() => currentRoute == route.routeName;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets containerPadding = EdgeInsets.all(20.0);

    final activeColor = Colors.lightBlueAccent;
    final inactiveColor = Colors.white60;

    final isActive = _isActiveRoute();

    return GestureDetector(
      onTap: () => AutoRouter.of(context).navigate(route),
      child: Container(
        padding: containerPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            // Icon and label
            Icon(
              isActive ? activeIcon : icon,
              size: 24.0,
              color: isActive ? activeColor : inactiveColor,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppItems {
  // List of AppNavBarItem objects
  static List<AppNavBarItem> getItems(String currentRoute) {
    return [
      AppNavBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: HomeStrings.homeNavBar,
        route: const HomeRoute(),
        currentRoute: currentRoute,
      ),
    ];
  }
}
