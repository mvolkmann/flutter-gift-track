import 'package:flutter/material.dart';
import 'my_text.dart';

// A Switch with off and on labels that can be tapped to set the value.
class MySwitch extends StatelessWidget {
  Color? offColor;
  final String offLabel;
  Color? onColor;
  final String onLabel;
  final ValueChanged<bool> onChanged;
  final bool value;

  MySwitch({
    Key? key,
    this.offColor,
    required this.offLabel,
    this.onColor,
    required this.onChanged,
    required this.onLabel,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    onColor ??= colorScheme.primary;
    offColor ??= Colors.orange; //colorScheme.secondary;

    return Row(
      children: [
        TextButton(
          child: MyText(offLabel, color: offColor),
          onPressed: () => onChanged(false),
        ),
        Switch(onChanged: onChanged, value: value),
        TextButton(
          child: MyText(onLabel, color: onColor),
          onPressed: () => onChanged(true),
        ),
      ],
    );
  }
}
