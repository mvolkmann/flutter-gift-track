import 'package:flutter/cupertino.dart';

class GiftsPage extends StatefulWidget {
  static const route = '/gifts'; // used to register route

  const GiftsPage({Key? key}) : super(key: key);

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  var adding = false;

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('Gifts'));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue,
        middle: Text('Gifts'),
        trailing: CupertinoButton(
          child: Text(adding ? 'Done' : 'Add'),
          onPressed: () {
            setState(() => adding = !adding);
          },
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(child: _buildBody(context)),
    );
  }
}
