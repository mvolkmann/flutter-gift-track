import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../widgets/my_text.dart';
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
    appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Gifts',
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFab(icon: CupertinoIcons.add, onPressed: _add),
      body: FutureBuilder(
        future: loadData(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching data: ${snapshot.error}');
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }

          return Column(
            children: [
              GiftPickers(),
              SizedBox(height: 10),
              for (var gift in gifts) _buildListTile(gift),
              Spacer(),
              Text(
                'Total: ${formatPrice(_getTotal())}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).margin(EdgeInsets.only(bottom: 90)),
            ],
          );
        },
      ).center.padding(20),
    );
  }

  Widget _buildListTile(Gift gift) {
    final description = gift.description;
    final price = gift.price;
    return CupertinoListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => GiftPage(gift: gift),
        ),
      ),
      subtitle: description == null ? null : MyText(description),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(gift.name),
          MyText(formatPrice(price)),
        ],
      ),
    );
  }

  int _getTotal() =>
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
