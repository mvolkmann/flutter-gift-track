import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../extensions/widget_extensions.dart';
import '../models/occasion.dart';
import '../app_state.dart';
import '../widgets/my_text_button.dart';

const fakeYear = 1;

class OccasionPage extends StatefulWidget {
  static const route = '/occasion';

  final Occasion occasion;

  const OccasionPage({required this.occasion, Key? key}) : super(key: key);

  @override
  State<OccasionPage> createState() => _OccasionPageState();
}

class _OccasionPageState extends State<OccasionPage> {
  late AppState _appState;
  late bool _isNew;
  late Occasion _occasion;
  late TextEditingController _nameController;
  var _includeDate = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.occasion.id == 0;
    _occasion = _isNew ? Occasion(name: '') : widget.occasion;
    _nameController = TextEditingController(text: _occasion.name);
    _nameController.addListener(() {
      setState(() => _occasion.name = _nameController.text);
    });
    _includeDate = _isNew ? false : _occasion.date != null;
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Occasion',
      trailing: _buildAddUpdateButton(context),
      child: _buildBody(context),
    );
  }

  MyTextButton _buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: _isNew ? 'Add' : 'Update',
      onPressed: () {
        if (_isNew) {
          _appState.addOccasion(_occasion);
        } else {
          _appState.updateOccasion(_occasion);
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
          _buildDateRow(),
          if (_includeDate && _occasion.date != null) _buildDatePicker()
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget _buildDateRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Include Date'),
          CupertinoSwitch(
            value: _includeDate,
            onChanged: (bool value) {
              _includeDate = value;
              setState(() {
                if (_includeDate) {
                  final now = DateTime.now();
                  _occasion.date = DateTime(fakeYear, now.month, now.day);
                } else {
                  _occasion.date = null;
                }
              });
            },
          ),
        ],
      );

  SizedBox _buildDatePicker() => SizedBox(
        height: 150,
        child: Stack(
          children: [
            CupertinoDatePicker(
              initialDateTime: _occasion.date,
              maximumYear: fakeYear,
              minimumYear: fakeYear,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) {
                value = DateTime(fakeYear, value.month, value.day);
                setState(() => _occasion.date = value);
              },
            ),
            // This covers the "1" for the fake year since
            // currently there is no way to ask CupertinoDatePicker
            // to only display wheels for month and day.
            Positioned(
              top: 55,
              right: 8,
              child: Container(
                color: CupertinoColors.white,
                height: 40,
                width: 80,
              ),
            ),
          ],
        ),
      );

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.delete),
          backgroundColor: CupertinoColors.destructiveRed,
          elevation: 200,
          onPressed: () {
            _appState.deleteOccasion(_occasion);
            Navigator.pop(context);
          },
        ),
      );

  CupertinoTextField _buildNameField() => CupertinoTextField(
        clearButtonMode: OverlayVisibilityMode.always,
        controller: _nameController,
        placeholder: 'Name',
      );
}
