import 'package:flutter/cupertino.dart';

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
    return Text('Settings go here.');
  }
}
