import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import './pages/about_page.dart';
import './pages/gifts_page.dart';
import './pages/occasions_page.dart';
import './pages/people_page.dart';
import './pages/person_page.dart';
import './pages/settings_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = 'Gift Track';
    var home = ChangeNotifierProvider(
      create: (context) => AppState(),
      child: HomePage(),
    );
    return CupertinoApp(
      home: home,
      routes: {
        AboutPage.route: (_) => AboutPage(),
        GiftsPage.route: (_) => GiftsPage(),
        OccasionsPage.route: (_) => OccasionsPage(),
        PeoplePage.route: (_) => PeoplePage(),
        PersonPage.route: (_) => PersonPage(),
        SettingsPage.route: (_) => SettingsPage(),
      },
      theme: CupertinoThemeData(brightness: Brightness.light),
      title: title,
    );
  }
}

class PageDescriptor {
  final String title;
  final IconData icon;
  final Widget page;

  PageDescriptor(this.title, this.icon, this.page);
}

var aboutIcon = CupertinoIcons.info;
var peopleIcon = CupertinoIcons.person_3_fill;
var occasionsIcon = Icons.cake_rounded;
var giftsIcon = CupertinoIcons.gift_fill;
var settingsIcon = CupertinoIcons.gear_solid;

//TODO: Why aren't constructor tear-offs working?
//TODO: Why can't the type here be replaced by var?
List<PageDescriptor> pages = <PageDescriptor>[
  PageDescriptor('About', aboutIcon, AboutPage()),
  PageDescriptor('People', peopleIcon, PeoplePage()),
  PageDescriptor('Occasions', occasionsIcon, OccasionsPage()),
  PageDescriptor('Gifts', giftsIcon, GiftsPage()),
  PageDescriptor('Settings', settingsIcon, SettingsPage()),
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = pages
        .map(
          (page) => BottomNavigationBarItem(
            icon: Icon(page.icon),
            label: page.title,
          ),
        )
        .toList();

    // See CupertinoColors.
    // Change page background to CupertinoColors.activeBlue.
    // style argument can be set to
    // CupertinoTheme.of(context).textTheme.navLargeTitltTextStyle.
    // Material has a single Scaffold class, but Cupertino has two:
    // CupertinoPageScaffold and CupertinoTabScaffold.
    // It is common to use the first inside the second.
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: items),
      tabBuilder: (context, index) => CupertinoTabView(
        builder: (BuildContext context) => pages[index].page,
      ),
    );
  }
}
