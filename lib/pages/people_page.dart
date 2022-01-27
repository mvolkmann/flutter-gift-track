import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

//import '../extensions/widget_extensions.dart';
import '../state.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  var adding = false;

  Widget _buildBody(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var people = appState.people;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        //child: Text('Can you see me?'),
        child: Column(
          children: [
            if (adding) PersonForm(),
            if (!adding)
              Column(
                children: [
                  Text('People Count: ${people.length}'),
                  for (var person in people) Text('name = ${person.name}')
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('People'),
        trailing: CupertinoButton(
          child: Text(adding ? 'Done' : 'Add'),
          onPressed: () {
            // If "Done" was pressed, save a new person.
            if (adding) {
              //TODO: Modify appState here.
              //TODO: But how can you get the state from PersonForm?
            }
            setState(() => adding = !adding);
          },
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(child: _buildBody(context)),
    );
  }
}

class PersonForm extends StatefulWidget {
  const PersonForm({Key? key}) : super(key: key);

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  var _birthday = DateTime.now();
  var _includeBirthday = false;
  final _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      print('name is now ${_nameController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    //var appState = Provider.of<AppState>(context);
    //var person = appState.person;

    return Form(
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
                  setState(() => _includeBirthday = value);
                  if (!value) _birthday = DateTime.now();
                },
              ),
            ],
          ),
          if (_includeBirthday)
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                initialDateTime: _birthday,
                maximumYear: 2200,
                minimumYear: 1900,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  setState(() => _birthday = value);
                },
              ),
            )
        ].vSpacing(10),
      ),
    );
  }
}
