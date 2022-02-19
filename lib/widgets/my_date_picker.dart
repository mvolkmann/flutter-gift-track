import 'package:flutter/cupertino.dart';

class MyDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final int? maxYear;
  final int minYear;
  final void Function(DateTime) onDateChanged;
  final bool hideYear;

  const MyDatePicker({
    Key? key,
    this.hideYear = false,
    this.initialDate,
    this.maxYear,
    this.minYear = 1,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = CupertinoDatePicker(
      initialDateTime: initialDate,
      maximumYear: hideYear ? 1 : maxYear,
      minimumYear: hideYear ? 1 : minYear,
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: onDateChanged,
    );

    if (!hideYear) return SizedBox(height: 150, child: picker);

    // This covers the "1" for the fake year since
    // currently there is no way to ask CupertinoDatePicker
    // to only display wheels for month and day.
    final cover = Positioned(
      top: 55,
      right: 8,
      child: Container(
        color: CupertinoColors.white,
        height: 40,
        width: 80,
      ),
    );

    return SizedBox(height: 150, child: Stack(children: [picker, cover]));
  }
}
