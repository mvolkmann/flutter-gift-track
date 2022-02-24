import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class MyButton extends StatelessWidget {
  final Color? backgroundColor;
  final bool compact;
  final Color? foregroundColor;
  final bool filled;
  final IconData? icon;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final String? text;

  const MyButton({
    Key? key,
    this.backgroundColor,
    this.compact = false,
    this.filled = false,
    this.foregroundColor,
    this.icon,
    required this.onPressed,
    this.padding,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final child = icon == null
        ? Text(
            text ?? '',
            style: TextStyle(color: foregroundColor ?? appState.titleColor),
          )
        : Icon(icon);
    final pad = padding ??
        (compact ? const EdgeInsets.symmetric(horizontal: 10) : null);
    return CupertinoButton(
      child: child,
      color: filled ? backgroundColor ?? appState.backgroundColor : null,
      onPressed: onPressed,
      padding: pad,
    );
  }
}
