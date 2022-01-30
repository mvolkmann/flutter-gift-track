import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import './occasion_page.dart';
import '../state.dart';
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
    var appState = Provider.of<AppState>(context);
    var occasions = appState.occasions;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text('Occasion Count: ${occasions.length}'),
            for (var occasion in occasions) Text('name = ${occasion.name}')
          ],
        ),
      ),
    );
  }
}
