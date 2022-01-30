import 'package:flutter/cupertino.dart';

import './my_page.dart';
import './occasion_page.dart';

class OccasionsPage extends StatelessWidget {
  static const route = '/occasions';

  OccasionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Occasions',
      child: _buildBody(context),
      trailing: CupertinoButton(
        child: Text(
          'Add',
          style: TextStyle(color: CupertinoColors.white),
        ),
        onPressed: () {
          Navigator.pushNamed(context, OccasionPage.route);
        },
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('List occasions here.'));
  }
}
