import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:provider/provider.dart';

import './my_page.dart';
import './occasion_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/occasion.dart';
import '../util.dart' show formatDate, offerPurchase;
import '../widgets/my_fab.dart';
import '../widgets/my_list_tile.dart';

class OccasionsPage extends StatelessWidget {
  static const route = '/occasions';

  OccasionsPage({Key? key}) : super(key: key);

  void _add(BuildContext context, bool canAdd) async {
    if (!canAdd) {
      final purchased = await offerPurchase(context);
      if (!purchased) return;
    }

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
    );
  }

  Widget _buildBody(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final occasions = appState.sortedOccasions;
    final canAdd = appState.paid || occasions.length < 2;

    final body = appState.isLoaded
        ? ListView.builder(
            itemCount: occasions.length,
            itemBuilder: (context, index) {
              final occasion = occasions[index];
              return MyListTile(
                onTap: () => _edit(context, occasion),
                title: occasion.name,
                subtitle: formatDate(occasion.date),
              );
            },
          )
        : CupertinoActivityIndicator();

    return Scaffold(
      floatingActionButton: MyFab(
        icon: CupertinoIcons.add,
        onPressed: (_) => _add(context, canAdd),
      ),
      body: body.center.padding(20),
    );
  }

  void _edit(BuildContext context, Occasion occasion) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => OccasionPage(occasion: occasion),
      ),
    );
  }
}
