import 'package:flutter/cupertino.dart';

import './gift_page.dart';
import './my_page.dart';

class GiftsPage extends StatelessWidget {
  static const route = '/gifts';

  GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Gifts',
      child: _buildBody(context),
      trailing: CupertinoButton(
        child: Text(
          'Add',
          style: TextStyle(color: CupertinoColors.white),
        ),
        onPressed: () {
          Navigator.pushNamed(context, GiftPage.route);
        },
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('List gifts here.'));
  }
}
