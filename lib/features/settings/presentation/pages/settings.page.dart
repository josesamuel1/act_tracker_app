import 'package:act_tracker/core/core.dart';
import 'package:act_tracker/features/settings/presentation/strings/strings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingsPage extends StatelessWidget with UserMixin {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayoutContainer(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              logoutUser();

              if (context.mounted) {
                context.router.replaceAll([AuthRoute()]);
              }
            },
            child: Text(SettingsStrings.logoutButton),
          ),
        ],
      ),
    );
  }
}
