import 'dart:async' show Completer;
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import './extensions/widget_extensions.dart';
import './widgets/my_button.dart';

Future<bool> confirm(BuildContext context, String question) {
  final completer = Completer<bool>();
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(question),
      content: Column(
        children: [
          Row(
            children: [
              MyButton(
                text: 'Cancel',
                onPressed: () {
                  completer.complete(false);
                  Navigator.pop(context);
                },
              ),
              MyButton(
                text: 'OK',
                onPressed: () {
                  completer.complete(true);
                  Navigator.pop(context);
                },
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ).gap(10)
        ],
      ),
    ),
  );
  return completer.future;
}

String? formatDate(DateTime? date) {
  if (date == null) return null;
  final format = date.year <= 1 ? 'M/d' : 'M/d/y';
  return DateFormat(format).format(date);
}

String formatPrice(int? price) {
  final formatter = NumberFormat.decimalPattern();
  return price == null ? '' : '\$${formatter.format(price)}';
}

DateTime? msToDateTime(int? ms) =>
    ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);

Future<Color?> pickColor({
  required BuildContext context,
  String? title,
  required Color color,
}) {
  final completer = Completer<Color?>();
  var selectedColor = color;
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title ?? 'Color Picker'),
      content: Column(
        children: [
          ColorPicker(
            pickerColor: color,
            onColorChanged: (color) {
              selectedColor = color;
            },
          ),
          MyButton(
            text: 'Select Color',
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
