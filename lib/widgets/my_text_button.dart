import 'package:flutter/cupertino.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const MyTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(
        text,
        style: TextStyle(color: CupertinoColors.white),
      ),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
    );
  }
}
