import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import '../widgets/my_text.dart';

class MyListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String? subtitle;
  final String title;
  final String? trailing;

  const MyListTile({
    Key? key,
    required this.onTap,
    this.subtitle,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget titleWidget = trailing == null
        ? MyText(title)
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(title),
              MyText(trailing!),
            ],
          );
    return CupertinoListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      subtitle: subtitle == null ? null : MyText(subtitle!),
      title: titleWidget,
    );
  }
}
