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
  late AppState _appState;
  var _gifts = <Gift>[];
  var _occasions = <Occasion>[];
  var _people = <Person>[];

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
    _appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Gifts',
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFab(icon: CupertinoIcons.add, onPressed: _add),
      body: FutureBuilder(
        future: _loadData(context),
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
              for (var gift in _gifts) _buildListTile(gift),
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
      _gifts.fold(0, (int acc, Gift gift) => acc + (gift.price ?? 0));

  Future<void> _loadData(BuildContext context) async {
    if (_occasions.isEmpty) {
      _occasions = _appState.sortedOccasions;
      if (_occasions.isNotEmpty) {
        await _appState.selectOccasion(_occasions[0], index: 0, silent: true);
      }
    }

    if (_people.isEmpty) {
      _people = _appState.sortedPeople;
      if (_people.isNotEmpty) {
        await _appState.selectPerson(_people[0], index: 0, silent: true);
      }
    }

    _gifts = _appState.gifts.values.toList();
  }
}
