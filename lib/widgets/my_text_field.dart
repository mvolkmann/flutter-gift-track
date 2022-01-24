import 'package:flutter/material.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';

typedef ValidatorFn = String? Function(String?);

class MyTextField extends StatefulWidget {
  final String hintText;
  final String initialValue;
  final String labelText;
  final bool obscureText;
  final void Function(String) onChanged;
  final ValidatorFn? validator;

  const MyTextField({
    Key? key,
    this.hintText = '',
    this.initialValue = '',
    this.labelText = '',
    this.obscureText = false,
    this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    var validator = widget.validator;
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // Note how "widget" is used to access
        // properties in the StatefulWidget above.
        hintText: widget.hintText,
        labelText: widget.labelText,
      ),
      initialValue: widget.initialValue,
      obscureText: widget.obscureText,
      onChanged: (String value) => widget.onChanged(value),
      validator: validator,
    ).pad(10);
  }
}
