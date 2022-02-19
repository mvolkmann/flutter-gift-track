import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import './my_page.dart';
import './occasion_page.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../models/occasion.dart';
import '../util.dart' show formatDate;
import '../widgets/my_text.dart';

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
    );
  }

  Widget _buildBody(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final occasions = appState.sortedOccasions;

    final body = appState.isLoaded
        ? ListView.builder(
            itemCount: occasions.length,
            itemBuilder: (context, index) {
              final occasion = occasions[index];
              return _buildListTile(context, occasion);
            },
          )
        : CircularProgressIndicator();

    return Scaffold(
      floatingActionButton: _buildFab(context),
      body: body.center.padding(20),
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

  Widget _buildListTile(BuildContext context, Occasion occasion) =>
      CupertinoListTile(
        //border: Border.all(color: Colors.green),
        contentPadding: EdgeInsets.zero,
        onTap: () => _edit(context, occasion),
        title: MyText(occasion.name),
        subtitle: occasion.date == null
            ? null
            : MyText(
                formatDate(occasion.date!),
              ),
      );

  void _edit(BuildContext context, Occasion occasion) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => OccasionPage(occasion: occasion),
      ),
    );
  }
}
