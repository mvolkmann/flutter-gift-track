import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings'; // used to register route

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var adding = false;

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('Settings'));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue,
        middle: Text('Settings'),
      ),
      child: SafeArea(child: _buildBody(context)),
    );
  }
}
