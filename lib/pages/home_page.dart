import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors

import 'about_page.dart';
import 'gifts_page.dart';
import 'occasions_page.dart';
import 'people_page.dart';
import 'settings_page.dart';

class PageDescriptor {
  final String title;
  final IconData icon;
  final Widget page;

  PageDescriptor(this.title, this.icon, this.page);
}

//TODO: Why aren't constructor tear-offs working?
//TODO: Why can't the type here be replaced by var?
List<PageDescriptor> pages = <PageDescriptor>[
  PageDescriptor('About', CupertinoIcons.info, AboutPage()),
  PageDescriptor('People', CupertinoIcons.person_3_fill, PeoplePage()),
  PageDescriptor('Occasions', Icons.cake_rounded, OccasionsPage()),
  PageDescriptor('Gifts', CupertinoIcons.gift_fill, GiftsPage()),
  PageDescriptor('Settings', CupertinoIcons.gear_solid, SettingsPage()),
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = pages
        .map((page) => BottomNavigationBarItem(
              icon: Icon(page.icon),
              label: page.title,
            ))
        .toList();

    // See CupertinoColors.
    // Change page background to CupertinoColors.activeBlue.
    // style argument can be set to
    // CupertinoTheme.of(context).textTheme.navLargeTitltTextStyle.
    // Material has a single Scaffold class, but Cupertino has two:
    // CupertinoPageScaffold and CupertinoTabScaffold.
    // It is common to use the first inside the second.
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: items,
        ),
        tabBuilder: (context, index) => CupertinoTabView(
              builder: (BuildContext context) => CupertinoPageScaffold(
                navigationBar:
                    CupertinoNavigationBar(middle: Text(pages[index].title)),
                child: pages[index].page,
              ),
            ));
  }
}
