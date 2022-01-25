import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/widgets/my_switch.dart';
import 'package:flutter_gift_track/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

//import '../extensions/widget_extensions.dart';
import '../state.dart';

// Change this to StatefulWidget to hold only array of people?
class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var adding = appState.adding;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Text(
              'People',
              textAlign: TextAlign.center,
            ),
            if (!adding) Text('show list of people'),
            if (adding) PersonForm(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class PersonForm extends StatefulWidget {
  const PersonForm({Key? key}) : super(key: key);

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  var birthday = DateTime.now();
  var includeBirthday = false;
  var name = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          MyTextField(
            initialValue: name,
            labelText: 'Name',
            onChanged: (value) {
              print('value is $value');
              setState(() => name = value);
            },
          ),
          MySwitch(
            offLabel: 'Omit Birthday',
            onLabel: 'Include Birthday',
            onChanged: (value) {
              setState(() => includeBirthday = value);
            },
            value: includeBirthday,
          ),
          if (includeBirthday)
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: birthday,
                maximumYear: 2200,
                minimumYear: 1900,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {
                  setState(() => birthday = value);
                },
              ),
            )
        ],
      ),
    );
  }
}
