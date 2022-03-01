import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../extensions/widget_extensions.dart';

import '../app_state.dart';
import '../util.dart' show offerPurchase;
import '../widgets/my_button.dart';

class AboutPage extends StatelessWidget {
  // This should match the value of
  // flutter.versionName in android/local.properties.
  static const version = '1.0.5';

  static const route = '/about';

  static const intro = 'This app tracks gift ideas and purchased gifts for '
      'multiple people and multiple occasions throughout the year. '
      'To use it, follow the steps below:';

  static const inAppPurchase = '''
You are using the free version of the app which is limited
to tracking gifts for two people and two occasions.
If you attempt to add more people or occassions,
you will be prompted to make an in-app purchase
which enables tracking gifts for an
unlimited number of people and occasions.
''';

  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    fetchOffers(context);
    final appState = Provider.of<AppState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Gift Track',
            style: TextStyle(
              color: appState.titleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        const Text('version ${version}'),
        const Text(''),
        const Text(intro),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(''),
          Text('1. Tap \'People\' and add people.'),
          Text('2. Tap \'Occasions\' and add occasions.'),
          Text('3. Tap \'Gifts\' and add gifts '
              'for specific people and occasions.'),
          Text(''),
          if (appState.paid)
            MyButton(
              backgroundColor: appState.titleColor,
              compact: true,
              filled: true,
              foregroundColor: appState.backgroundColor,
              text: 'Unpurchase',
              onPressed: () => appState.paid = false,
            ),
          if (!appState.paid) Text(inAppPurchase.replaceAll('\n', ' ')),
          if (!appState.paid)
            MyButton(
              backgroundColor: appState.titleColor,
              compact: true,
              filled: true,
              foregroundColor: appState.backgroundColor,
              text: 'Purchase',
              onPressed: () => offerPurchase(context),
            ).margin(const EdgeInsets.only(top: 20)),
        ]),
      ],
    )
        .padding(20)
        .textColor(CupertinoColors.white)
        .backgroundColor(appState.backgroundColor);
  }

  void fetchOffers(BuildContext context) async {
    /*
    final offerings = await PurchaseApi.fetchOffers();
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No offerings found.'),
        ),
      );
    } else {
      final offer = offerings.first;
      print('about_page.dart fetchOffers: offer = $offer');
      //TODO: Add a fancier UI to display each offer in a Card and ListTile.
    }
    */
  }
}
