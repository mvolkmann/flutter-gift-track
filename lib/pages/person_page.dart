import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../extensions/widget_extensions.dart';
import '../models/person.dart';
import '../app_state.dart';
import '../util.dart' show confirm;
import '../widgets/my_text_button.dart';

class PersonPage extends StatefulWidget {
  static const route = '/person';

  final Person person;

  const PersonPage({required this.person, Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late AppState _appState;
  late bool _isNew;
  late Person _person;
  late TextEditingController _nameController;
  var _includeBirthday = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.person.id == 0;
    _person = _isNew ? Person(name: '') : widget.person;
    _nameController = TextEditingController(text: _person.name);
    _nameController.addListener(() {
      setState(() => _person.name = _nameController.text);
    });
    _includeBirthday = _isNew ? false : _person.birthday != null;
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Person',
      trailing: _buildAddUpdateButton(context),
      child: _buildBody(context),
    );
  }

  MyTextButton _buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: _isNew ? 'Add' : 'Update',
      onPressed: () {
        if (_isNew) {
          _appState.addPerson(_person);
        } else {
          _appState.updatePerson(_person);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFab(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildNameField(),
          _buildBirthdayRow(),
          if (_includeBirthday) _buildDatePicker()
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget _buildBirthdayRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Include Birthday'),
          CupertinoSwitch(
            value: _includeBirthday,
            onChanged: (bool value) {
              _includeBirthday = value;
              setState(() {
                _person.birthday = _includeBirthday ? DateTime.now() : null;
              });
            },
          ),
        ],
      );

  SizedBox _buildDatePicker() => SizedBox(
        height: 150,
        child: CupertinoDatePicker(
          initialDateTime: _person.birthday,
          maximumYear: 2200,
          minimumYear: 1900,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime value) {
            setState(() => _person.birthday = value);
          },
        ),
      );

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.delete),
          backgroundColor: CupertinoColors.destructiveRed,
          elevation: 200,
          onPressed: () async {
            if (await confirm(context, 'Really delete?')) {
              _appState.deletePerson(_person);
              Navigator.pop(context);
            }
          },
        ),
      );

  CupertinoTextField _buildNameField() => CupertinoTextField(
        clearButtonMode: OverlayVisibilityMode.always,
        controller: _nameController,
        placeholder: 'Name',
      );
}
