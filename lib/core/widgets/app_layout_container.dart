import 'package:flutter/material.dart';

class AppLayoutContainer extends StatelessWidget {
  final Widget child;

  const AppLayoutContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        minimum: EdgeInsets.only(top: 36.0, left: 12.0, right: 12.0, bottom: 12.0),
        child: child,
      ),
    );
  }
}
