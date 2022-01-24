import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './pages/about_page.dart';
import './pages/gifts_page.dart';
import './pages/occasions_page.dart';
import './pages/people_page.dart';
import './pages/settings_page.dart';

var useMaterial = false; // false for Cupertino

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = 'Gift Track';
    var home = HomePage();
    return useMaterial
        ? MaterialApp(
            title: title,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: home,
          )
        : CupertinoApp(
            title: title,
            theme: CupertinoThemeData(brightness: Brightness.light),
            home: home,
          );
  }
}

class PageDescriptor {
  final String title;
  final IconData icon;
  final Widget page;

  PageDescriptor(this.title, this.icon, this.page);
}

//TODO: Why aren't constructor tear-offs working?
//TODO: Why can't the type here be replaced by var?
List<PageDescriptor> pages = <PageDescriptor>[
  PageDescriptor('About', Icons.info, AboutPage()),
  PageDescriptor('People', Icons.person, PeoplePage()),
  PageDescriptor('Occasions', Icons.cake, OccasionsPage()),
  PageDescriptor('Gifts', Icons.card_giftcard, GiftsPage()),
  PageDescriptor('Settings', Icons.settings, SettingsPage()),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

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
    return useMaterial
        ? Scaffold(
            appBar: AppBar(
              title: Text(pages[_pageIndex].title),
            ),
            body: Center(child: pages[_pageIndex].page),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              items: items,
              onTap: (int index) {
                setState(() => _pageIndex = index);
              },
              selectedItemColor: Colors.green,
              // Why isn't this defaulting to true?
              showUnselectedLabels: true,
              // Why isn't this defaulting to gray or black?
              unselectedItemColor: Colors.black45,
            ),
          )
        : CupertinoTabScaffold(
            tabBar: CupertinoTabBar(items: items),
            tabBuilder: (context, index) => CupertinoTabView(
              builder: (BuildContext context) => CupertinoPageScaffold(
                navigationBar:
                    CupertinoNavigationBar(middle: Text(pages[index].title)),
                child: pages[index].page,
              ),
            ),
          );
  }
}
