import 'package:flutter/cupertino.dart';

class MySwitch extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const MySwitch({
    Key? key,
    required this.label,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          CupertinoSwitch(onChanged: onChanged, value: value),
        ],
      );
}
