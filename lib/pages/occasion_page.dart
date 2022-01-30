import 'package:flutter/cupertino.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/occasion.dart';
import '../state.dart';
import '../widgets/my_text_button.dart';

//TODO: Modify to support both adding and editing an occasion.
//TODO: Get selected person from appState.
class OccasionPage extends StatefulWidget {
  static const route = '/occasion';

  const OccasionPage({Key? key}) : super(key: key);

  @override
  State<OccasionPage> createState() => _OccasionPageState();
}

class _OccasionPageState extends State<OccasionPage> {
  var occasion = Occasion(name: '');
  var _includeDate = false;
  final _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() => occasion.name = _nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Occasion',
      trailing: MyTextButton(
        text: 'Done',
        onPressed: () {
          if (occasion.name.isNotEmpty) appState.addOccasion(occasion);
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
                Text('Include Date'),
                CupertinoSwitch(
                  value: _includeDate,
                  onChanged: (value) {
                    setState(() {
                      _includeDate = value;
                      if (!value) occasion.date = DateTime.now();
                    });
                  },
                ),
              ],
            ),
            if (_includeDate)
              SizedBox(
                height: 150,
                child: CupertinoDatePicker(
                  initialDateTime: occasion.date,
                  maximumYear: 2200,
                  minimumYear: 1900,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    setState(() => occasion.date = value);
                  },
                ),
              )
          ].vSpacing(10),
        ),
      ),
    );
  }
}
