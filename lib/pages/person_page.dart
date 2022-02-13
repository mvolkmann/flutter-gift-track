import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/person.dart';
import '../services/database_service.dart';
import '../state.dart';
import '../widgets/my_text_button.dart';

//TODO: Modify to support both adding and editing a person.
class PersonPage extends StatefulWidget {
  static const route = '/person';

  //TODO: Should this come from appState instead of being passed in?
  final Person? person;

  const PersonPage({this.person, Key? key}) : super(key: key);

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
    _isNew = widget.person == null;
    _person = _isNew ? Person(name: '') : widget.person!;
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
            if (_person.name.isNotEmpty) appState.addPerson(_person);
          } else {
            DatabaseService.personService.update(_person);
            appState.updatePerson(_person);
          }
          Navigator.pop(context);
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
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
                CupertinoSwitch(
                  value: _includeBirthday,
                  onChanged: (bool value) {
                    _includeBirthday = value;
                    setState(() {
                      _person.birthday =
                          _includeBirthday ? DateTime.now() : null;
                    });
                  },
                ),
              ],
            ),
            if (_includeBirthday)
              SizedBox(
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
              )
          ].vSpacing(10),
        ),
      ),
    );
  }
}
