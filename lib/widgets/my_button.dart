import 'package:flutter/cupertino.dart';

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
    final child = icon == null ? Text(text ?? '') : Icon(icon);
    return filled
        ? CupertinoButton.filled(
            child: child,
            onPressed: onPressed,
            padding: padding,
          )
        : CupertinoButton(
            child: child,
            onPressed: onPressed,
            padding: padding,
          );
  }
}
