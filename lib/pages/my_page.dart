import 'package:flutter/cupertino.dart';

import '../widgets/my_text.dart';

class MyPage extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final String title;
  final Widget? trailing;

  const MyPage({
    Key? key,
    required this.child,
    this.leading,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue,
        leading: leading,
        middle: MyText(
          title,
          color: CupertinoColors.white,
          textAlign: TextAlign.center,
        ),
        trailing: trailing,
      ),
      child: Center(child: child),
    );
  }
}
