import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors

import 'about_page.dart';
import 'gifts_page.dart';
import 'occasions_page.dart';
import 'people_page.dart';
import 'settings_page.dart';

const titles = ['About', 'People', 'Occasions', 'Gifts', 'Settings'];
//TODO: Why aren't constructor tear-offs working?
const pages = [
  AboutPage(),
  PeoplePage(),
  OccasionsPage(),
  GiftsPage(),
  SettingsPage()
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // See CupertinoColors.
    // Change page background to CupertinoColors.activeBlue.
    // style argument can be set to
    // CupertinoTheme.of(context).textTheme.navLargeTitltTextStyle.
    // Material has a single Scaffold class, but Cupertino has two:
    // CupertinoPageScaffold and CupertinoTabScaffold.
    // It is common to use the first inside the second.
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3_fill),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake_rounded),
            label: 'Occasions',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gift_fill),
            label: 'Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_solid),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (BuildContext context) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text(titles[index])),
            child: pages[index],
          ),
        );
      },
    );
  }
}
