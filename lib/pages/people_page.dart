import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

//import '../extensions/widget_extensions.dart';
import '../models/person.dart';
import '../state.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

Person makePerson() => Person(name: '', birthday: DateTime.now());

class _PeoplePageState extends State<PeoplePage> {
  var adding = false;
  Person person = makePerson();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    print('adding = $adding');
    print('person = $person');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('People'),
        trailing: CupertinoButton(
          child: Text(adding ? 'Done' : 'Add'),
          onPressed: () {
            print('onPressed: adding = $adding');
            // If "Done" was pressed, save a new person.
            if (adding) {
              print('adding name = ${person.name}');
              appState.addPerson(person);
              person = makePerson();
            }
            setState(() => adding = !adding);
          },
          padding: EdgeInsets.zero,
        ),
      ),
      child: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var people = appState.people;
    for (var person in people) {
      print('person = $person');
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            if (adding) PersonForm(person: person),
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
}

class PersonForm extends StatefulWidget {
  final Person person;

  PersonForm({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  var person = Person(name: '', birthday: DateTime.now());
  var _includeBirthday = false;
  final _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      print('name is now ${_nameController.text}');
      setState(() => person.name = _nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
