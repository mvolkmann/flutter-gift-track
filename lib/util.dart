import 'dart:async' show Completer;
import 'package:flutter/cupertino.dart';
// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:provider/provider.dart';

import './app_state.dart';
import './extensions/widget_extensions.dart';
import './purchase_api.dart';
import './widgets/my_button.dart';

Future<void> alert(BuildContext context, String message) {
  final completer = Completer<void>();
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(message),
      content: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            MyButton(
              compact: true,
              filled: true,
              text: 'Close',
              onPressed: () {
                completer.complete();
                Navigator.pop(context);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ).gap(10),
      ),
    ),
  );
  return completer.future;
}

Future<bool> confirm(BuildContext context, String question) {
  final completer = Completer<bool>();
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(question),
      content: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            MyButton(
              compact: true,
              filled: true,
              text: 'Cancel',
              onPressed: () {
                completer.complete(false);
                Navigator.pop(context);
              },
            ),
            MyButton(
              compact: true,
              filled: true,
              text: 'OK',
              onPressed: () {
                completer.complete(true);
                Navigator.pop(context);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ).gap(10),
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

void offerPurchase(BuildContext context) async {
  try {
    final offers = await PurchaseApi.fetchOffers();
    print('util.dart offerPurchase: offers = $offers');
    final appState = Provider.of<AppState>(context, listen: false);
    const question = 'Pay \$1.99 to unlock features?';
    bool purchase = await confirm(context, question);
    appState.paid = purchase;
  } catch (e) {
    print('util.dart offerPurchase: e = $e');
  }
}
