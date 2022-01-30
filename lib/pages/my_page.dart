import 'package:flutter/cupertino.dart';

import '../widgets/my_text.dart';

class MyPage extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? trailing;

  const MyPage({
    Key? key,
    required this.child,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue,
        middle: MyText(title, color: CupertinoColors.white),
        trailing: trailing,
      ),
      child: Center(child: child),
    );
  }
}
