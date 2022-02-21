import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class MyButton extends StatelessWidget {
  final bool filled;
  final IconData? icon;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final String? text;

  const MyButton({
    Key? key,
    this.filled = false,
    this.icon,
    required this.onPressed,
    this.padding,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    final child = icon == null
        ? Text(text ?? '', style: TextStyle(color: appState.titleColor))
        : Icon(icon);
    return CupertinoButton(
      child: child,
      color: filled ? appState.backgroundColor : null,
      onPressed: onPressed,
      padding: padding,
    );
  }
}
