import 'dart:async' show Completer;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../extensions/widget_extensions.dart';

class MyColorPicker extends StatelessWidget {
  final Color initialColor;
  final void Function(Color) onSelected;
  final String title;

  MyColorPicker({
    Key? key,
    required this.initialColor,
    this.title = 'Color Picker',
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        height: 20,
        width: 20,
        color: initialColor,
      ).border(color: Colors.black),
      onPressed: () async {
        final newColor = await pickColor(
          context: context,
          title: title,
          color: initialColor,
        );
        onSelected(newColor);
      },
    );
  }

  Future<Color> pickColor({
    required BuildContext context,
    String? title,
    required Color color,
  }) {
    final completer = Completer<Color>();
    var selectedColor = color;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? 'Color Picker'),
        content: Column(
          children: [
            Card(
              child: ColorPicker(
                pickerColor: color,
                onColorChanged: (color) => selectedColor = color,
              ),
            ),
            CupertinoButton(
              child: Text('Select Color'),
              onPressed: () {
                completer.complete(selectedColor);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    return completer.future;
  }
}
