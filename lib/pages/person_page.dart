import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/person.dart';
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
  var _includeBirthday = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    var person = widget.person;
    _nameController =
        TextEditingController(text: person == null ? '' : person.name);
    _nameController.addListener(() {
      //TODO: Handle case where person is null to add a new person.
      setState(() => person.name = _nameController.text);
    });
    _includeBirthday = person == null ? false : person.birthday != null;
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var person = widget.person;

    return MyPage(
      title: 'Person',
      trailing: MyTextButton(
        text: person == null ? 'Add' : 'Update',
        onPressed: () {
          // This is only for adding a new person.
          if (person.name.isNotEmpty) appState.addPerson(person);
          Navigator.pop(context);
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var person = widget.person;
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
                      person.birthday =
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
                  initialDateTime: person.birthday,
                  maximumYear: 2200,
                  minimumYear: 1900,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    setState(() => person.birthday = value);
                  },
                ),
              )
          ].vSpacing(10),
        ),
      ),
    );
  }
}
