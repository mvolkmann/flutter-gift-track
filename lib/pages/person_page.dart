import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../extensions/widget_extensions.dart';
import '../models/person.dart';
import '../app_state.dart';
import '../util.dart' show alert, confirm;
import '../widgets/cancel_button.dart';
import '../widgets/my_date_picker.dart';
import '../widgets/my_fab.dart';
import '../widgets/my_switch.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_text_field.dart';

class PersonPage extends StatefulWidget {
  static const route = '/person';

  final Person person;

  const PersonPage({required this.person, Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late AppState appState;
  late bool isNew;
  late Person person;
  var includeBirthday = false;

  @override
  void initState() {
    super.initState();
    isNew = widget.person.id == 0;
    person = isNew ? Person(name: '') : widget.person.clone;
    includeBirthday = isNew ? false : person.birthday != null;
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);

    return MyPage(
      leading: CancelButton(),
      title: 'Person',
      trailing: buildAddUpdateButton(context),
      child: buildBody(context),
    );
  }

  Widget buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: 'Done',
      onPressed: () async {
        if (isNew) {
          await appState.addPerson(person);
        } else {
          await appState.updatePerson(person);
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
              foregroundColor: CupertinoColors.white,
              icon: CupertinoIcons.delete,
              onPressed: delete,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyTextField(
            initialText: person.name,
            listener: (text) {
              setState(() => person.name = text);
            },
            placeholder: 'Name',
          ),
          MySwitch(
              label: 'Include Birthday',
              value: includeBirthday,
              onChanged: (value) {
                includeBirthday = value;
                setState(() {
                  person.birthday = includeBirthday ? DateTime.now() : null;
                });
              }),
          if (includeBirthday)
            MyDatePicker(
              initialDate: person.birthday,
              maxYear: 2200,
              minYear: 1900,
              onDateChanged: (date) {
                setState(() => person.birthday = date);
              },
            ),
        ],
      ).gap(10).center.padding(20),
    );
  }

  void delete(BuildContext context) async {
    if (await confirm(
        context,
        'Deleting this person will also delete all of their gifts. '
        'Are you sure?')) {
      appState.deletePerson(person);
      Navigator.pop(context);
    }
  }
}
