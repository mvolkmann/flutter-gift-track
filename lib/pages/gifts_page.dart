import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:provider/provider.dart';

import './gift_page.dart';
import './my_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/gift.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../widgets/gift_pickers.dart';
import '../widgets/my_fab.dart';
import '../widgets/my_list_tile.dart';
import '../util.dart' show formatPrice;

class GiftsPage extends StatefulWidget {
  static const route = '/gifts';

  GiftsPage({Key? key}) : super(key: key);

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  late AppState appState;
  var gifts = <Gift>[];
  var occasions = <Occasion>[];
  var people = <Person>[];

  void add(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => GiftPage(gift: Gift(name: '')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Gifts',
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFab(icon: CupertinoIcons.add, onPressed: add),
      body: FutureBuilder(
        future: loadData(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching data: ${snapshot.error}');
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return CupertinoActivityIndicator();
          }

          return Column(
            children: [
              GiftPickers(),
              SizedBox(height: 10),
              for (var gift in gifts) buildListTile(gift),
              Spacer(),
              Text(
                'Total: ${formatPrice(getTotal())}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).margin(EdgeInsets.only(bottom: 90)),
            ],
          );
        },
      ).center.padding(20),
    );
  }

  Widget buildListTile(Gift gift) => MyListTile(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => GiftPage(gift: gift),
          ),
        ),
        subtitle: gift.description,
        title: gift.name,
        trailing: formatPrice(gift.price),
      );

  int getTotal() =>
      gifts.fold(0, (int acc, Gift gift) => acc + (gift.price ?? 0));

  Future<void> loadData(BuildContext context) async {
    if (occasions.isEmpty) {
      occasions = appState.sortedOccasions;
      if (occasions.isNotEmpty) {
        await appState.selectOccasion(occasions[0], index: 0, silent: true);
      }
    }

    if (people.isEmpty) {
      people = appState.sortedPeople;
      if (people.isNotEmpty) {
        await appState.selectPerson(people[0], index: 0, silent: true);
      }
    }

    gifts = appState.gifts.values.toList();
  }
}
