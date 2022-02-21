import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import './pages/about_page.dart';
import './pages/gifts_page.dart';
import './pages/occasions_page.dart';
import './pages/people_page.dart';
import './pages/settings_page.dart';
import './services/database_service.dart';

//void main() => runApp(const MyApp());
void main() {
  DatabaseService.setup().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: ChangeNotifierProvider(
        create: (context) => AppState(context: context),
        child: HomePage(),
      ),
      // This is needed to allow using some Material widgets
      // such as ColorPicker.
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        // This sets the color of the back button icon in the app bar.
        textTheme: CupertinoTextThemeData(
          //TODO: Get titleColor from appState.
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
  static const route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final controller =
        CupertinoTabController(initialIndex: appState.startPageIndex);

    final items = pages
        .map(
          (page) => BottomNavigationBarItem(
            icon: Icon(page.icon),
            label: page.title,
          ),
        )
        .toList();

    return CupertinoTabScaffold(
      controller: controller,
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
