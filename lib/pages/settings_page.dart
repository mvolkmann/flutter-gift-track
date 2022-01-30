import 'package:flutter/cupertino.dart';

import './my_page.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var adding = false;

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Settings',
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text('Settings go here.');
  }
}
