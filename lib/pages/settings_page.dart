import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

import '../extensions/widget_extensions.dart';
import '../widgets/my_button.dart';
import '../widgets/my_color_picker.dart';
import './my_page.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const pages = ['About', 'People', 'Occasions', 'Gifts', 'Settings'];
  var selectedPage = pages[0];

  Color backgroundColor = Colors.blue;
  Color titleColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: 'Settings',
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final picker = CupertinoPicker.builder(
      childCount: pages.length,
      itemBuilder: (_, index) => Text(pages[index]),
      itemExtent: 30,
      onSelectedItemChanged: (index) {
        setState(() => selectedPage = pages[index]);
      },
    );
    final textStyle = TextStyle(fontWeight: FontWeight.bold);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Background Color', style: textStyle),
            MyColorPicker(
              initialColor: backgroundColor,
              title: 'Background Color',
              onSelected: (color) {
                setState(() => backgroundColor = color);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Title Color', style: textStyle),
            MyColorPicker(
              initialColor: titleColor,
              title: 'Title Color',
              onSelected: (color) {
                setState(() => titleColor = color);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start Page', style: textStyle),
            SizedBox(child: picker, height: 130, width: 110),
          ],
        ),
        MyButton(
          filled: true,
          text: 'Reset',
          onPressed: () {},
        )
      ],
    ).gap(10).padding(20);
  }
}
