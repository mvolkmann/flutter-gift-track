import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:provider/provider.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import './my_page.dart';
import './person_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/person.dart';
import '../util.dart' show formatDate;
import '../widgets/my_text.dart';

class PeoplePage extends StatelessWidget {
  static const route = '/people';

  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'People',
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var people = appState.people.values.toList();
    people.sort((p1, p2) => p1.name.compareTo(p2.name));

    return Scaffold(
      floatingActionButton: _buildFab(context),
      body: Column(
        children: [
          Text('People Count: ${people.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                var person = people[index];
                return _buildListTile(context, person);
              },
            ),
          ),
        ],
      ).center.padding(20),
    );
  }

  void _add(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PersonPage(person: Person(name: '')),
      ),
    );
  }

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.add),
          elevation: 200,
          onPressed: () => _add(context),
        ),
      );

  Widget _buildListTile(BuildContext context, Person person) =>
      CupertinoListTile(
        //border: Border.all(color: Colors.green),
        contentPadding: EdgeInsets.zero,
        onTap: () => _edit(context, person),
        title: MyText(person.name),
        subtitle: person.birthday == null
            ? null
            : MyText(
                formatDate(person.birthday!),
              ),
      );

  void _edit(BuildContext context, Person person) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PersonPage(person: person),
      ),
    );
  }
}
