import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final void Function(String text) listener;
  final String initialText;
  final bool isInt;
  final String? placeholder;

  MyTextField({
    Key? key,
    required this.initialText,
    this.isInt = false,
    required this.listener,
    this.placeholder,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
    controller.addListener(() => widget.listener(controller.text));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatters = <TextInputFormatter>[];
    if (widget.isInt) formatters.add(FilteringTextInputFormatter.digitsOnly);

    return CupertinoTextField(
      clearButtonMode: OverlayVisibilityMode.always,
      controller: controller,
      inputFormatters: formatters,
      keyboardType: widget.isInt ? TextInputType.number : null,
      placeholder: widget.placeholder,
    );
  }
}
