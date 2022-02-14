import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../extensions/widget_extensions.dart';
import '../models/person.dart';
import '../app_state.dart';
import '../widgets/my_text_button.dart';

class PersonPage extends StatefulWidget {
  static const route = '/person';

  final Person person;

  const PersonPage({required this.person, Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late bool _isNew;
  late Person _person;
  var _includeBirthday = false;
  late TextEditingController _nameController;

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
    var appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Person',
      trailing: MyTextButton(
        text: _isNew ? 'Add' : 'Update',
        onPressed: () {
          if (_isNew) {
            appState.addPerson(_person);
          } else {
            appState.updatePerson(_person);
          }
          Navigator.pop(context);
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CupertinoTextField(
          clearButtonMode: OverlayVisibilityMode.always,
          controller: _nameController,
          placeholder: 'Name',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Include Birthday'),
            _buildBirthdaySwitch(),
          ],
        ),
        if (_includeBirthday) _buildDatePicker()
      ].vSpacing(10),
    ).center.padding(20);
  }

  CupertinoSwitch _buildBirthdaySwitch() => CupertinoSwitch(
        value: _includeBirthday,
        onChanged: (bool value) {
          _includeBirthday = value;
          setState(() {
            _person.birthday = _includeBirthday ? DateTime.now() : null;
          });
        },
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
}
