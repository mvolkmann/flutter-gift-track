import 'dart:io' show Platform;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import './app_state.dart';
import './secrets.dart';
import './util.dart' show alert, confirm;

bool canPurchase = false;

Future<List<Offering>> _fetchOffers() async {
  try {
    await _init();
    if (!canPurchase) return [];
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    return current == null ? [] : [current];
    //} on PlatformException catch (e) {
  } catch (e) {
    print('error getting RevenueCat offerings: $e');
    return [];
  }
}

Future<void> _init() async {
  final availability = await GoogleApiAvailability.instance
      .checkGooglePlayServicesAvailability(true);
  canPurchase = availability == GooglePlayServicesAvailability.success;
  if (!canPurchase) return;

  // This causes debugging log messages to be output.
  //await Purchases.setDebugLogsEnabled(true);

  if (Platform.isAndroid) {
    await Purchases.setup(revenueCatApiKey);
  } else if (Platform.isIOS) {
    //await Purchases.setup('public_ios_sdk_key');
    throw 'iOS is not supported yet.';
  }
}

Future<bool> offerPurchase(BuildContext context) async {
  try {
    final offerings = await _fetchOffers();
    final offer = offerings.firstOrNull;
    final package = offer?.availablePackages.firstOrNull;
    final product = package?.product;
    //final entitlement = ?;

    var purchase = false;
    if (product == null) {
      await alert(context, 'No in-app purchase offerings were found.');
    } else {
      final question = product.description +
          ' Pay ${product.priceString} ${product.currencyCode} for this?';
      purchase = await confirm(context, question);
      if (purchase) {
        //TODO: This is not working in the Android emulator!
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
