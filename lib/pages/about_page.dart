import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors
import 'package:flutter/widgets.dart';
//import '../extensions/widget_extensions.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const intro = 'This app tracks gift ideas and purchased gifts for '
        'multiple people and multiple occasions throughout the year.';

    final inAppPurchase = '''
You are using the free version of the app which is limited
to tracking gifts for two people and two occasions.
If you attempt to add more people or occassions,
you will be prompted to make an in-app purchase
which enables tracking gifts for an
unlimited number of people and occasions.
'''
        .replaceAll('\n', ' ');

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Gift Track',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text(''),
          const Text(intro),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('To use it, follow the steps below:'),
            Text(''),
            Text('1. Tap \'People\' and add people.'),
            Text('2. Tap \'Occasions\' and add occasions.'),
            Text('3. Tap \'Gifts\' and add gifts '
                'for specific people and occasions.'),
            Text(''),
            Text(inAppPurchase),
          ]),
        ]));
  }
}
