import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import '../widgets/my_text.dart';

class MyListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String? subtitle;
  final String title;

  const MyListTile({
    Key? key,
    required this.onTap,
    this.subtitle,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      subtitle: subtitle == null ? null : MyText(subtitle!),
      title: MyText(title),
    );
  }
}
