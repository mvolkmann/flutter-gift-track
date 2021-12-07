import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors
import 'package:flutter/widgets.dart';
import './debug_border.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const intro = 'This app tracks gift ideas and purchased gifts for '
        'multiple people and multiple occasions throughout the year.';

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
            Text('1. Tap \'People\' and add people.').debugBorder,
            Text('2. Tap \'Occasions\' and add occasions.'),
            Text('3. Tap \'Gifts\' and add gifts '
                'for specific people and occasions.'),
          ]),
        ]));
  }
}
