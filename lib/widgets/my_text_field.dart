import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? placeholder;
  final bool isInt;

  const MyTextField({
    Key? key,
    required this.controller,
    this.isInt = false,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatters = <TextInputFormatter>[];
    if (isInt) formatters.add(FilteringTextInputFormatter.digitsOnly);

    return CupertinoTextField(
      clearButtonMode: OverlayVisibilityMode.always,
      controller: controller,
      inputFormatters: formatters,
      keyboardType: isInt ? TextInputType.number : null,
      placeholder: placeholder,
    );
  }
}
