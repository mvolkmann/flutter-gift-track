import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final bool bold;
  final Color? color;
  final double size;
  final String text;
  final TextAlign? textAlign;

  const MyText(
    this.text, {
    Key? key,
    this.bold = false,
    this.color,
    this.size = 14,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? defaultColor = Theme.of(context).textTheme.bodyText1?.color;
    Color theColor = color ?? defaultColor ?? Colors.black;
    FontWeight weight = bold ? FontWeight.bold : FontWeight.normal;
    return Text(
      text,
      style: TextStyle(color: theColor, fontSize: size, fontWeight: weight),
      textAlign: textAlign,
    );
  }
}
