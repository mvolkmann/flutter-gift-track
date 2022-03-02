import 'dart:io' show Platform;
import 'package:purchases_flutter/purchases_flutter.dart';

import './secrets.dart';

class PurchaseApi {
  static Future<void> init() async {
    print('purchase_api.dart init: entered');
    await Purchases.setDebugLogsEnabled(true);
    if (Platform.isAndroid) {
      await Purchases.setup(revenueCatApiKey);
    } else if (Platform.isIOS) {
      //await Purchases.setup('public_ios_sdk_key');
      throw 'iOS is not supported yet.';
    }
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
      //} on PlatformException catch (e) {
    } catch (e) {
      print('error getting RevenueCat offerings: $e');
      return [];
    }
  }
}
