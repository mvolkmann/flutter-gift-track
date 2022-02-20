import 'dart:io' show File;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../widgets/cancel_button.dart';
import '../widgets/my_button.dart';
import '../widgets/my_fab.dart';
import '../widgets/my_switch.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_text_field.dart';

class GiftPage extends StatefulWidget {
  static const route = '/gift';

  final Gift gift;

  const GiftPage({required this.gift, Key? key}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  late AppState appState;
  late bool isNew;
  late bool purchased;
  late Gift gift;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    isNew = widget.gift.id == 0;
    gift = isNew ? Gift(name: '') : widget.gift.clone;

    descriptionController = TextEditingController(text: gift.description);
    descriptionController.addListener(() {
      setState(() => gift.description = descriptionController.text);
    });

    locationController = TextEditingController(text: gift.location);
    locationController.addListener(() {
      setState(() => gift.location = locationController.text);
    });

    nameController = TextEditingController(text: gift.name);
    nameController.addListener(() {
      setState(() => gift.name = nameController.text);
    });

    priceController = TextEditingController(
      text: (gift.price ?? 0).toString(),
    );
    priceController.addListener(() {
      final text = priceController.text;
      final price = text.isEmpty ? 0 : int.parse(text);
      setState(() => gift.price = price);
    });

    purchased = gift.purchased;
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    final occasion = appState.selectedOccasion!;
    final person = appState.selectedPerson!;
    final name = nameController.text;

    return MyPage(
      leading: CancelButton(),
      title: '${occasion.name} Gift\nfor ${person.name}',
      trailing: name.isEmpty ? null : buildAddUpdateButton(context),
      child: buildBody(context),
    );
  }

  Widget buildAddUpdateButton(BuildContext context) {
    return MyTextButton(
      text: 'Done',
      onPressed: () async {
        if (isNew) {
          await appState.addGift(gift);
        } else {
          await appState.updateGift(gift);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: isNew
          ? null
          : MyFab(
              backgroundColor: CupertinoColors.destructiveRed,
              icon: CupertinoIcons.delete,
              onPressed: delete,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyTextField(controller: nameController, placeholder: 'Name'),
          MyTextField(
              controller: descriptionController, placeholder: 'Description'),
          MyTextField(
              controller: priceController, placeholder: 'Price', isInt: true),
          MySwitch(
            label: 'Purchased?',
            value: purchased,
            onChanged: (value) {
              setState(() => purchased = gift.purchased = value);
            },
          ),
          buildPhotoRow(),
          MyTextField(controller: locationController, placeholder: 'Location'),
          buildButtons(context),
        ],
      ).gap(10).center.padding(20),
    );
  }

  Widget buildButtons(BuildContext context) {
    return Row(
      children: [
        MyButton(
          filled: true,
          text: 'Move',
          onPressed: () => moveGift(context),
        ),
        MyButton(
          filled: true,
          text: 'Copy',
          onPressed: () => copyGift(context),
        ),
      ],
    ).gap(10);
  }

  Widget buildPhotoButton(IconData icon, ImageSource source) {
    return MyButton(
      icon: icon,
      onPressed: () async {
        final picker = ImagePicker();
        XFile? image = await picker.pickImage(source: source);
        if (image == null) return;
        setState(() => gift.photo = image.path);
      },
      padding: EdgeInsets.only(right: 20),
    );
  }

  Widget buildPhotoRow() {
    final photo = gift.photo;
    return Row(
      children: [
        Column(
          children: [
            buildPhotoButton(CupertinoIcons.camera, ImageSource.camera),
            buildPhotoButton(CupertinoIcons.photo, ImageSource.gallery),
          ],
        ),
        if (photo != null)
          Image(
            image: FileImage(File(photo)),
            height: 135,
            width: 200,
          ),
      ],
    );
  }

  void copyGift(BuildContext context) {
    showBottomSheet(
      buttonText: 'Copy',
      child: GiftPickers(),
      context: context,
      onPressed: () async {
        await appState.copyGift(gift);
        Navigator.pop(context); // pops bottom sheet
        Navigator.pop(context); // pops gift page
      },
    );
  }

  void delete(BuildContext context) async {
    if (await confirm(context, 'Really delete?')) {
      appState.deleteGift(gift);
      Navigator.pop(context);
    }
  }

  void moveGift(BuildContext context) {
    showBottomSheet(
      buttonText: 'Move',
      child: GiftPickers(),
      context: context,
      onPressed: () async {
        await appState.moveGift(gift);
        Navigator.pop(context); // pops bottom sheet
        Navigator.pop(context); // pops gift page
      },
    );
  }

  void showBottomSheet({
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
                  MyButton(text: buttonText, onPressed: onPressed),
                  MyButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
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
