// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

String formatDate(DateTime date) {
  final format = date.year <= 1 ? 'M/d' : 'M/d/y';
  return DateFormat(format).format(date);
}

String formatPrice(int? price) {
  final formatter = NumberFormat.decimalPattern();
  return price == null ? '' : '\$${formatter.format(price)}';
}

DateTime? msToDateTime(int? ms) =>
    ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
