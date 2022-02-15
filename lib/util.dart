// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat;

String formatDate(DateTime date) {
  final format = date.year == 0 ? 'M/d' : 'M/d/y';
  return DateFormat(format).format(date);
}

DateTime? msToDateTime(int? ms) =>
    ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
