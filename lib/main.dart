import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import './pages/about_page.dart';
import './pages/gifts_page.dart';
import './pages/occasions_page.dart';
import './pages/people_page.dart';
import './pages/settings_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = AppState();
    return CupertinoApp(
      home: ChangeNotifierProvider(
        create: (context) => state,
        child: HomePage(),
      ),
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        // This sets the color of the back button icon in the app bar.
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.white,
        ),
      ),
      title: 'Gift Track',
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
  static const route = '/';

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

    // Notes for blog:
    // - See CupertinoColors.
    // - Change page background to CupertinoColors.activeBlue?
    // - style argument can be set to
    //   CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.
    // - Material has a single Scaffold class, but Cupertino has two:
    //   CupertinoPageScaffold and CupertinoTabScaffold.
    //   It is common to use the first inside the second.

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: items),
      tabBuilder: (context, index) => CupertinoTabView(
        builder: (BuildContext context) => pages[index].page,
        routes: {
          AboutPage.route: (_) => AboutPage(),
          GiftsPage.route: (_) => GiftsPage(),
          OccasionsPage.route: (_) => OccasionsPage(),
          PeoplePage.route: (_) => PeoplePage(),
          SettingsPage.route: (_) => SettingsPage(),
        },
      ),
    );
  }
}
