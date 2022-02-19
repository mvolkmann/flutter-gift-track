import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../extensions/widget_extensions.dart';
import '../models/occasion.dart';
import '../app_state.dart';
import '../util.dart' show confirm;
import '../widgets/cancel_button.dart';
import '../widgets/my_fab.dart';
import '../widgets/my_text_button.dart';

const fakeYear = 1;

class OccasionPage extends StatefulWidget {
  static const route = '/occasion';

  final Occasion occasion;

  const OccasionPage({required this.occasion, Key? key}) : super(key: key);

  @override
  State<OccasionPage> createState() => _OccasionPageState();
}

class _OccasionPageState extends State<OccasionPage> {
  late AppState appState;
  late bool isNew;
  late Occasion occasion;
  late TextEditingController nameController;
  var includeDate = false;

  @override
  void initState() {
    super.initState();
    isNew = widget.occasion.id == 0;
    occasion = isNew ? Occasion(name: '') : widget.occasion.clone;
    nameController = TextEditingController(text: occasion.name);
    nameController.addListener(() {
      setState(() => occasion.name = nameController.text);
    });
    includeDate = isNew ? false : occasion.date != null;
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return MyPage(
      leading: CancelButton(),
      title: 'Occasion',
      trailing: buildAddUpdateButton(context),
      child: buildBody(context),
    );
  }

  Widget buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: 'Done',
      onPressed: () {
        if (isNew) {
          appState.addOccasion(occasion);
        } else {
          appState.updateOccasion(occasion);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: isNew
          ? null
          : MyFab(
              backgroundColor: CupertinoColors.destructiveRed,
              icon: CupertinoIcons.delete,
              onPressed: delete,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildNameField(),
          buildDateRow(),
          if (includeDate && occasion.date != null) buildDatePicker()
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget buildDateRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Include Date'),
          CupertinoSwitch(
            value: includeDate,
            onChanged: (bool value) {
              includeDate = value;
              setState(() {
                if (includeDate) {
                  final now = DateTime.now();
                  occasion.date = DateTime(fakeYear, now.month, now.day);
                } else {
                  occasion.date = null;
                }
              });
            },
          ),
        ],
      );

  SizedBox buildDatePicker() => SizedBox(
        height: 150,
        child: Stack(
          children: [
            CupertinoDatePicker(
              initialDateTime: occasion.date,
              maximumYear: fakeYear,
              minimumYear: fakeYear,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) {
                value = DateTime(fakeYear, value.month, value.day);
                setState(() => occasion.date = value);
              },
            ),
            // This covers the "1" for the fake year since
            // currently there is no way to ask CupertinoDatePicker
            // to only display wheels for month and day.
            Positioned(
              top: 55,
              right: 8,
              child: Container(
                color: CupertinoColors.white,
                height: 40,
                width: 80,
              ),
            ),
          ],
        ),
      );

  CupertinoTextField buildNameField() => CupertinoTextField(
        clearButtonMode: OverlayVisibilityMode.always,
        controller: nameController,
        placeholder: 'Name',
      );

  void delete(BuildContext context) async {
    if (await confirm(context, 'Really delete?')) {
      appState.deleteOccasion(occasion);
      Navigator.pop(context);
    }
  }
}
