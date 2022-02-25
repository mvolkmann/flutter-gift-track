import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';
import './pages/about_page.dart';
import './pages/gifts_page.dart';
import './pages/occasions_page.dart';
import './pages/people_page.dart';
import './pages/settings_page.dart';
import './services/database_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider must be wrapped around CupertinoApp
    // and not just HomePage in order to access AppState in a dialog.
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(context: context),
      child: CupertinoApp(
        // This removes the diagonal DEBUG banner from the upper-right
        // that is displayed by default when running in debug mode.
        debugShowCheckedModeBanner: false,
        home: HomePage(),
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
            primaryColor: CupertinoColors.white,
          ),
        ),
        title: 'Gift Track',
      ),
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

  HomePage({Key? key}) : super(key: key);

  Future<int> getStartPageIndex() async {
    await DatabaseService.setup();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('startPageIndex') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final items = pages
        .map(
          (page) => BottomNavigationBarItem(
            icon: Icon(page.icon),
            label: page.title,
          ),
        )
        .toList();

    return FutureBuilder<int>(
      future: getStartPageIndex(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: CupertinoColors.white,
            child: CupertinoActivityIndicator(),
          );
        }

        final tabIndex = snapshot.data!;
        final controller = CupertinoTabController(initialIndex: tabIndex);
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
      },
    );
  }
}
