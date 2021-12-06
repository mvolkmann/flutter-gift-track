import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // defines Colors
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      /*
      navigationBar: CupertinoNavigationBar(
        middle: Text('Gift Track')
      ),
      */
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
            icon: Icon(CupertinoIcons.question), // need better icon
            label: 'Occasions',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gift_fill),
            label: 'Gifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        late final CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: AboutPage(),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: PeoplePage(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: OccasionsPage(),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: GiftsPage(),
              );
            });
            break;
          case 4:
            returnValue = CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: SettingsPage(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const intro = 'This app tracks gift ideas and purchased gifts for '
        'multiple people and multiple occasions throughout the year.';

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Gift Track",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text(''),
          const Text(intro),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('To use it, follow the steps below:'),
            Text(''),
            Text('1. Tap \'People\' and add people.'),
            Text('2. Tap \'Occasions\' and add occasions.'),
            Text('3. Tap \'Gifts\' and add gifts '
                'for specific people and occasions.'),
          ]),
        ]));
  }
}

class DebugBorder extends StatelessWidget {
  final Widget child;
  const DebugBorder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: child);
  }
}

class GiftsPage extends StatelessWidget {
  const GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Gifts"),
    );
  }
}

class OccasionsPage extends StatelessWidget {
  const OccasionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Occasions"),
    );
  }
}

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("People"),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Settings"),
    );
  }
}
