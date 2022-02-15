import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import './gift_page.dart';
import './my_page.dart';
import '../app_state.dart';
import '../models/named.dart';
import '../widgets/my_text_button.dart';

class GiftsPage extends StatelessWidget {
  static const route = '/gifts';

  GiftsPage({Key? key}) : super(key: key);

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
    var appState = Provider.of<AppState>(context);
    var occasions = appState.occasions.values.toList();
    var people = appState.people.values.toList();
    occasions.sort((o1, o2) => o1.name.compareTo(o2.name));
    people.sort((p1, p2) => p1.name.compareTo(p2.name));

    return Column(
      children: [
        Row(
          children: [
            _buildPicker(people),
            _buildPicker(occasions),
          ],
        ),
        Text('Add gift list here.'),
      ],
    );
  }

  Flexible _buildPicker(List<Named> items) {
    const itemHeight = 30.0;
    const pickerHeight = 150.0;
    final decoration = BoxDecoration(
      border: Border.all(color: CupertinoColors.destructiveRed),
    );

    return Flexible(
      child: Container(
        child: CupertinoPicker.builder(
          childCount: items.length,
          itemBuilder: (_, index) => Text(items[index].name),
          itemExtent: itemHeight,
          onSelectedItemChanged: (index) {
            //selectedPerson = people[index],
            print('gifts_page.dart _buildBody: index = $index');
          },
        ),
        decoration: decoration,
        height: pickerHeight,
      ),
    );
  }
}
