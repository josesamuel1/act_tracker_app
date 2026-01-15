import 'package:act_tracker/core/core.dart';
import 'package:act_tracker/features/home/presentation/widgets/app_nav_bar_item.dart';
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ValueListenableBuilder<String>(
        valueListenable: RouteNotifier.currentRoute,
        builder: (_, route, _) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(24.0),
            ),
            height: 90.0,
            margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AppItems.getItems(route),
            ),
          );
        },
      ),
    );
  }
}
