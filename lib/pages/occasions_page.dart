import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/occasion.dart';
import './occasion_page.dart';
import '../app_state.dart';
import '../widgets/my_text_button.dart';

class OccasionsPage extends StatelessWidget {
  static const route = '/occasions';

  OccasionsPage({Key? key}) : super(key: key);

  void _add(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => OccasionPage(occasion: Occasion(name: '')),
      ),
    );
  }

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
    var occasions = appState.occasions.values.toList();
    occasions.sort((o1, o2) => o1.name.compareTo(o2.name));

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

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.add),
          elevation: 200,
          onPressed: () => _add(context),
        ),
      );
}
