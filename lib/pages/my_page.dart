import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../widgets/my_text.dart';

class MyPage extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final String title;
  final double titleSize;
  final Widget? trailing;

  const MyPage({
    Key? key,
    required this.child,
    this.leading,
    required this.title,
    this.titleSize = 24,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: appState.backgroundColor,
        leading: leading,
        middle: MyText(
          title,
          bold: true,
          color: appState.titleColor,
          size: titleSize,
          textAlign: TextAlign.center,
        ),
        trailing: trailing,
      ),
      child: Center(child: child),
    );
  }
}
