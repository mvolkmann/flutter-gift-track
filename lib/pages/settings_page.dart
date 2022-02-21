import 'package:flutter/cupertino.dart';

import '../extensions/widget_extensions.dart';
import '../widgets/my_button.dart';
import './my_page.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Settings',
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Background Color'),
            Text('Picker goes here'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Title Color'),
            Text('Picker goes here'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start Page'),
            Text('Picker goes here'),
          ],
        ),
        MyButton(
          filled: true,
          text: 'Reset',
          onPressed: () {},
        )
      ],
    ).gap(10).padding(20);
  }
}
