import 'package:flutter/material.dart';
import 'my_text.dart';

// A Switch with off and on labels that can be tapped to set the value.
class MySwitch extends StatelessWidget {
  final Color offColor;
  final String offLabel;
  final Color onColor;
  final String onLabel;
  final ValueChanged<bool> onChanged;
  final bool value;

  const MySwitch({
    Key? key,
    this.offColor = Colors.red,
    required this.offLabel,
    this.onColor = Colors.green,
    required this.onChanged,
    required this.onLabel,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          child: MyText(offLabel, bold: !value, color: offColor),
          onPressed: () => onChanged(false),
        ),
        Switch(onChanged: onChanged, value: value),
        TextButton(
          child: MyText(onLabel, bold: value, color: onColor),
          onPressed: () => onChanged(true),
        ),
      ],
    );
  }
}
