import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:provider/provider.dart';

import './gift_page.dart';
import './my_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/gift.dart';
import '../models/named.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../widgets/my_text_button.dart';

class GiftsPage extends StatelessWidget {
  static const route = '/gifts';

  GiftsPage({Key? key}) : super(key: key);

  void _add(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => GiftPage(gift: Gift(name: '')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Gifts',
      child: _buildBody(context),
      trailing: MyTextButton(
        text: 'Add',
        onPressed: () {
          Navigator.pushNamed(context, GiftPage.route);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final occasions = appState.occasions.values.toList();
    final people = appState.people.values.toList();
    occasions.sort((o1, o2) => o1.name.compareTo(o2.name));
    people.sort((p1, p2) => p1.name.compareTo(p2.name));
    if (occasions.isNotEmpty) {
      appState.selectOccasion(occasions[0], silent: true);
    }
    if (people.isNotEmpty) {
      appState.selectPerson(people[0], silent: true);
    }

    return Scaffold(
      floatingActionButton: _buildFab(context),
      body: Column(
        children: [
          Row(
            children: [
              _buildPicker(context, 'Person', people),
              _buildPicker(context, 'Occasion', occasions),
            ],
          ),
          Text('Add gift list here.'),
        ],
      ).center.padding(20),
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

  Flexible _buildPicker(BuildContext context, String title, List<Named> items) {
    const itemHeight = 30.0;
    const pickerHeight = 150.0;
    final decoration = BoxDecoration(
      border: Border.all(color: CupertinoColors.lightBackgroundGray),
    );
    //var titleStyle = CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    var titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Flexible(
      child: Column(
        children: [
          Text(title, style: titleStyle),
          Container(
            child: CupertinoPicker.builder(
              childCount: items.length,
              itemBuilder: (_, index) => Text(items[index].name),
              itemExtent: itemHeight,
              onSelectedItemChanged: (index) {
                final appState = Provider.of<AppState>(context);
                if (title == 'Person') {
                  appState.selectPerson(items[index] as Person);
                }
                if (title == 'Occasion') {
                  appState.selectOccasion(items[index] as Occasion);
                }
              },
            ),
            decoration: decoration,
            height: pickerHeight,
          ),
        ],
      ),
    );
  }
}
