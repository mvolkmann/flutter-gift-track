import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/gift.dart';
import '../models/occasion.dart';
import '../models/person.dart';
import '../app_state.dart';
import '../widgets/my_text_button.dart';

//TODO: Modify to support both adding and editing an gift.
//TODO: Get selected person from appState.
class GiftPage extends StatefulWidget {
  static const route = '/gift';

  final Gift gift;

  const GiftPage({required this.gift, Key? key}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  var occasion = Occasion(name: ''); // select from wheel
  var person = Person(name: ''); // select from wheel

  var _includeBirthday = false;
  final _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() => widget.gift.name = _nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    final gift = widget.gift;

    return MyPage(
      title: 'Gift',
      trailing: MyTextButton(
        text: 'Done',
        onPressed: () {
          if (gift.name.isNotEmpty) {
            appState.addGift(
              person: person,
              occasion: occasion,
              gift: gift,
            );
          }
          Navigator.pop(context);
        },
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final gift = widget.gift;

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
                      if (!value) gift.date = DateTime.now();
                    });
                  },
                ),
              ],
            ),
            if (_includeBirthday)
              SizedBox(
                height: 150,
                child: CupertinoDatePicker(
                  initialDateTime: gift.date,
                  maximumYear: 2200,
                  minimumYear: 1900,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    setState(() => gift.date = value);
                  },
                ),
              )
          ].vSpacing(10),
        ),
      ),
    );
  }
}
