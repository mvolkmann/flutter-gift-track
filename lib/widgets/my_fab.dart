import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class MyFab extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData icon;
  final void Function(BuildContext) onPressed;

  const MyFab({
    Key? key,
    this.backgroundColor,
    this.foregroundColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bgColor = backgroundColor ?? appState.backgroundColor;
    final fgColor = foregroundColor ?? appState.titleColor;

    return Padding(
      child: FloatingActionButton(
        backgroundColor: bgColor,
        child: Icon(icon, color: fgColor),
        elevation: 200,
        onPressed: () => onPressed(context),
      ),
      // This moves the FloatingActionButton above bottom navigation area.
      padding: const EdgeInsets.only(bottom: 47),
    );
  }
}
