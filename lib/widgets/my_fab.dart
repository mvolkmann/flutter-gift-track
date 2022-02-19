import 'package:flutter/material.dart';

class MyFab extends StatelessWidget {
  final Color? backgroundColor;
  final IconData icon;
  final void Function(BuildContext) onPressed;

  const MyFab({
    Key? key,
    this.backgroundColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        child: Icon(icon),
        elevation: 200,
        onPressed: () => onPressed(context),
      ),
      // This moves the FloatingActionButton above bottom navigation area.
      padding: const EdgeInsets.only(bottom: 47),
    );
  }
}
