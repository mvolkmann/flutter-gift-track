import 'package:flutter/material.dart';
import './my_text_button.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextButton(
      text: 'Cancel',
      onPressed: () => Navigator.pop(context),
    );
  }
}
