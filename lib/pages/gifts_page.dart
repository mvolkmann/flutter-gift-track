import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './gift_page.dart';
import './my_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/gift.dart';
import '../models/named.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../widgets/my_text.dart';
import '../util.dart' show formatPrice;

class GiftsPage extends StatefulWidget {
  static const route = '/gifts';

  GiftsPage({Key? key}) : super(key: key);

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
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
    return MyPage(
      title: 'Gifts',
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(context),
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
              Row(
                children: [
                  _buildPicker(context, 'Person', _people),
                  _buildPicker(context, 'Occasion', _occasions),
                ],
              ),
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

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.add),
          elevation: 200,
          onPressed: () => _add(context),
        ),
      );

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

  Flexible _buildPicker(BuildContext context, String title, List<Named> items) {
    const itemHeight = 30.0;
    const pickerHeight = 150.0;
    final decoration = BoxDecoration(
      border: Border.all(color: CupertinoColors.lightBackgroundGray),
    );
    //var titleStyle = CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    var titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

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

  int _getTotal() =>
      _gifts.fold(0, (int acc, Gift gift) => acc + (gift.price ?? 0));

  Future<void> _loadData(BuildContext context) async {
    final appState = Provider.of<AppState>(context);

    _occasions = appState.occasions.values.toList();
    _occasions.sort((o1, o2) => o1.name.compareTo(o2.name));
    if (_occasions.isNotEmpty) {
      await appState.selectOccasion(_occasions[0], silent: true);
    }

    _people = appState.people.values.toList();
    _people.sort((p1, p2) => p1.name.compareTo(p2.name));
    if (_people.isNotEmpty) {
      await appState.selectPerson(_people[0], silent: true);
    }

    _gifts = appState.gifts.values.toList();
  }
}
