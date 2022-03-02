import 'dart:async' show Completer;
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException;
// See https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

Future<bool> offerPurchase(BuildContext context) async {
  try {
    final offerings = await PurchaseApi.fetchOffers();
    final offer = offerings.firstOrNull;
    print('util.dart offerPurchase: offer = $offer');
    final package = offer?.availablePackages.firstOrNull;
    final product = package?.product;
    //final entitlement = ?;
    print('util.dart offerPurchase: product = $product');

    var purchase = false;
    if (product == null) {
      await alert(context, 'No in-app purchase offerings were found.');
    } else {
      final question = product.description +
          ' Pay ${product.priceString} ${product.currencyCode} for this?';
      purchase = await confirm(context, question);
      if (purchase) {
        print('util.dart offerPurchase: purchasing');
        final purchaserInfo = await Purchases.purchasePackage(package!);
        final entitlement = purchaserInfo.entitlements.all[product.identifier];
        if (entitlement != null && entitlement.isActive) {
          final appState = Provider.of<AppState>(context, listen: false);
          appState.paid = purchase;
        }
      }
    }
    return purchase;
  } on PlatformException catch (e) {
    var errorCode = PurchasesErrorHelper.getErrorCode(e);
    if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
      //TODO: Find a better way to display errors.
      print('util.dart offerPurchase: errorCode = $errorCode');
    }
    return false;
  } catch (e) {
    //TODO: Find a better way to display errors.
    print('util.dart offerPurchase: e = $e');
    return false;
  }
}
