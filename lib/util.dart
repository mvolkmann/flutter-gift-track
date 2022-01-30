// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat;

String formatDate(DateTime date) => DateFormat('M/d/y').format(date);
