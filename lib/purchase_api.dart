import 'package:purchases_flutter/purchases_flutter.dart';

import './secrets.dart';

class PurchaseApi {
  static Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(revenueCatApiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
      //} on PlatformException catch (e) {
    } catch (e) {
      print('error getting RevenueCat offerings: ${e}');
      return [];
    }
  }
}
