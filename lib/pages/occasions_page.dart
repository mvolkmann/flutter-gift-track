import 'package:flutter/cupertino.dart';

import './my_page.dart';
import './occasion_page.dart';
import '../widgets/my_text_button.dart';

class OccasionsPage extends StatelessWidget {
  static const route = '/occasions';

  OccasionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Occasions',
      child: _buildBody(context),
      trailing: MyTextButton(
        text: 'Add',
        onPressed: () {
          Navigator.pushNamed(context, OccasionPage.route);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(child: Text('List occasions here.'));
  }
}
