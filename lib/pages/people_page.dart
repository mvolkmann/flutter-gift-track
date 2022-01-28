import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../state.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatelessWidget {
  static const route = '/people'; // used to register route

  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('People'),
        trailing: CupertinoButton(
          child: Text('Add'),
          onPressed: () {
            Navigator.pushNamed(context, '/person');
          },
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(child: _buildBody(context)),
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
