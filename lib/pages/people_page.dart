import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import './person_page.dart';
import '../state.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatelessWidget {
  static const route = '/people';

  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'People',
      child: _buildBody(context),
      trailing: CupertinoButton(
        child: Text(
          'Add',
          style: TextStyle(color: CupertinoColors.white),
        ),
        onPressed: () {
          Navigator.pushNamed(context, PersonPage.route);
        },
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var people = appState.people;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text('People Count: ${people.length}'),
            for (var person in people) Text('name = ${person.name}')
          ],
        ),
      ),
    );
  }
}
