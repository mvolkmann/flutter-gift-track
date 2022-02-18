import 'dart:io' show File;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import './my_page.dart';
import '../models/gift.dart';
import '../app_state.dart';
import '../extensions/widget_extensions.dart';
import '../util.dart' show confirm;
import '../widgets/gift_pickers.dart';
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
  XFile? _photoFile;

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
      final price = text.isEmpty ? 0 : int.parse(text);
      setState(() => _gift.price = price);
    });

    _purchased = _gift.purchased;
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);
    final occasion = _appState.selectedOccasion!;
    final person = _appState.selectedPerson!;
    final name = _nameController.text;

    return MyPage(
      title: '${occasion.name} Gift for ${person.name}',
      trailing: name.isEmpty ? null : _buildAddUpdateButton(context),
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
          _buildImageRow(),
          _buildTextField(
            placeholder: 'Location',
            controller: _locationController,
          ),
          _buildButtons(context),
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        CupertinoButton.filled(
          child: Text('Move'),
          onPressed: () => _moveGift(context),
        ),
        CupertinoButton.filled(
          child: Text('Copy'),
          onPressed: () => _copyGift(context),
        ),
      ],
    ).gap(10);
  }

  Widget _buildFab(BuildContext context) => Padding(
        // This moves the FloatingActionButton above bottom navigation area.
        padding: const EdgeInsets.only(bottom: 47),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.delete),
          backgroundColor: CupertinoColors.destructiveRed,
          elevation: 200,
          onPressed: () async {
            if (await confirm(context, 'Really delete?')) {
              _appState.deleteGift(_gift);
              Navigator.pop(context);
            }
          },
        ),
      );

  Widget _buildImageRow() {
    final image = FileImage(File(_photoFile!.path));
    return Row(
      children: [
        Column(
          children: [
            _buildImageButton(CupertinoIcons.camera, ImageSource.camera),
            _buildImageButton(CupertinoIcons.photo, ImageSource.gallery),
          ],
        ),
        if (_photoFile != null) Image(image: image, height: 135, width: 200),
      ],
    );
  }

  Widget _buildImageButton(IconData icon, ImageSource source) {
    return CupertinoButton(
      child: Icon(icon),
      onPressed: () async {
        final _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: source);
        if (image == null) return;
        setState(() => _photoFile = image);
      },
      padding: EdgeInsets.only(right: 20),
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

  void _copyGift(BuildContext context) {
    _showBottomSheet(
      buttonText: 'Copy',
      child: GiftPickers(),
      context: context,
      onPressed: () async {
        await _appState.copyGift(_gift);
        Navigator.pop(context); // pops bottom sheet
        Navigator.pop(context); // pops gift page
      },
    );
  }

  void _moveGift(BuildContext context) {
    _showBottomSheet(
      buttonText: 'Move',
      child: GiftPickers(),
      context: context,
      onPressed: () async {
        await _appState.moveGift(_gift);
        Navigator.pop(context); // pops bottom sheet
        Navigator.pop(context); // pops gift page
      },
    );
  }

  void _showBottomSheet({
    required String buttonText,
    required BuildContext context,
    required Widget child,
    required VoidCallback onPressed,
  }) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            children: [
              child,
              Row(
                children: [
                  CupertinoButton(
                    child: Text(buttonText),
                    onPressed: onPressed,
                  ),
                  CupertinoButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ).padding(20),
        );
      },
    );
  }
}
