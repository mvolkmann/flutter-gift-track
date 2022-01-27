import 'package:flutter/cupertino.dart';

class OccasionsPage extends StatefulWidget {
  const OccasionsPage({Key? key}) : super(key: key);

  @override
  State<OccasionsPage> createState() => _OccasionsPageState();
}

class _OccasionsPageState extends State<OccasionsPage> {
  var adding = false;

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('Occasions'));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Occasions'),
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
