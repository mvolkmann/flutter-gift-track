import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Scaffold;
import 'package:flutter/services.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/gift.dart';
import '../app_state.dart';
import '../widgets/my_text_button.dart';

class GiftPage extends StatefulWidget {
  static const route = '/gift';

  final Gift gift;

  const GiftPage({required this.gift, Key? key}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  late AppState _appState;
  late bool _isNew;
  late bool _purchased;
  late Gift _gift;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _isNew = widget.gift.id == 0;
    _gift = _isNew ? Gift(name: '') : widget.gift;

    _descriptionController = TextEditingController(text: _gift.description);
    _descriptionController.addListener(() {
      setState(() => _gift.description = _descriptionController.text);
    });

    _locationController = TextEditingController(text: _gift.location);
    _locationController.addListener(() {
      setState(() => _gift.location = _locationController.text);
    });

    _nameController = TextEditingController(text: _gift.name);
    _nameController.addListener(() {
      setState(() => _gift.name = _nameController.text);
    });

    _priceController = TextEditingController(
      text: (_gift.price ?? 0).toString(),
    );
    _priceController.addListener(() {
      final text = _priceController.text;
      print('gift_page.dart x: text = $text');
      final price = text.isEmpty ? 0 : int.parse(text);
      setState(() => _gift.price = price);
    });

    _purchased = _gift.purchased;
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);

    return MyPage(
      title: 'Gift',
      trailing: _buildAddUpdateButton(context),
      child: _buildBody(context),
    );
  }

  MyTextButton _buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: _isNew ? 'Add' : 'Update',
      onPressed: () {
        if (_isNew) {
          _appState.addGift(_gift);
        } else {
          _appState.updateGift(_gift);
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
          _buildTextField(
            placeholder: 'Name',
            controller: _nameController,
          ),
          _buildTextField(
            placeholder: 'Description',
            controller: _descriptionController,
          ),
          _buildTextField(
            placeholder: 'Price',
            controller: _priceController,
            isInt: true,
          ),
          _buildPurchasedRow(),
          _buildTextField(
            placeholder: 'Location',
            controller: _locationController,
          ),
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.delete),
          backgroundColor: CupertinoColors.destructiveRed,
          elevation: 200,
          onPressed: () {
            _appState.deleteGift(_gift);
            Navigator.pop(context);
          },
        ),
      );

  CupertinoTextField _buildTextField({
    required String placeholder,
    required TextEditingController controller,
    bool isInt = false,
  }) {
    var formatters = <TextInputFormatter>[];
    if (isInt) formatters.add(FilteringTextInputFormatter.digitsOnly);

    return CupertinoTextField(
      clearButtonMode: OverlayVisibilityMode.always,
      controller: controller,
      inputFormatters: formatters,
      keyboardType: isInt ? TextInputType.number : null,
      placeholder: placeholder,
    );
  }

  Widget _buildPurchasedRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Purchased?'),
          CupertinoSwitch(
            value: _purchased,
            onChanged: (value) {
              setState(() {
                _purchased = value;
              });
            },
          ),
        ],
      );
}
