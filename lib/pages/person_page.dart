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
  final Person person;

  const PersonPage({required this.person, Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  var person = Person(name: '');
  var _includeBirthday = false;
  final _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() => person.name = _nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Person',
      trailing: MyTextButton(
        text: 'Done',
        onPressed: () {
          if (person.name.isNotEmpty) appState.addPerson(person);
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
                  onChanged: (value) {
                    setState(() {
                      _includeBirthday = value;
                      if (!value) person.birthday = DateTime.now();
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
