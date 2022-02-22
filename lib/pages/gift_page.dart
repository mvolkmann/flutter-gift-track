import 'dart:async' show Completer;
import 'dart:io' show File;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../widgets/my_map.dart';
import '../widgets/my_switch.dart';
import '../widgets/my_text_button.dart';
import '../widgets/my_text_field.dart';
import '../geolocation.dart';

class GiftPage extends StatefulWidget {
  static const route = '/gift';

  final Gift gift;

  const GiftPage({required this.gift, Key? key}) : super(key: key);

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  late AppState appState;
  late TextEditingController descriptionController;
  late Gift gift;
  late bool isNew;
  LatLng? location;
  late TextEditingController locationController;
  final mapControllerCompleter = Completer<GoogleMapController>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late bool purchased;

  @override
  void initState() {
    super.initState();

    isNew = widget.gift.id == 0;
    gift = isNew ? Gift(name: '') : widget.gift.clone;

    if (!isNew && gift.latitude != null && gift.longitude != null) {
      location = LatLng(gift.latitude!, gift.longitude!);
    }

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
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    mapControllerCompleter.future.then((controller) => controller.dispose());
    nameController.dispose();
    priceController.dispose();
    super.dispose();
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
      titleSize: 18,
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
              foregroundColor: CupertinoColors.white,
              icon: CupertinoIcons.delete,
              onPressed: delete,
            ),
      body: ListView(
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
            MyTextField(
                controller: locationController, placeholder: 'Location'),
            if (location == null)
              MyButton(filled: true, text: 'Save Map', onPressed: saveLocation),
            if (location != null)
              MyMap(
                initialZoom: gift.zoom,
                location: location!,
                onCleared: clearMap,
                onLocationChanged: changeMapLocation,
                onZoomChanged: changeMapZoom,
              ),
            buildButtons(context),
          ].vSpacing(10),
          padding: EdgeInsets.all(20)),
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

  void changeMapLocation(LatLng location) {
    setState(() {
      gift.latitude = location.latitude;
      gift.longitude = location.longitude;
    });
  }

  void changeMapZoom(double zoom) {
    setState(() => gift.zoom = zoom);
  }

  void clearMap() {
    setState(() {
      location = null;
      gift.latitude = null;
      gift.longitude = null;
      gift.zoom = Gift.defaultZoom;
    });
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

  void saveLocation() async {
    final havePermission = await getGeolocationPermission();
    if (havePermission) {
      final position = await getGeolocation();
      setState(() {
        location = LatLng(position.latitude, position.longitude);
        gift.latitude = position.latitude;
        gift.longitude = position.longitude;
      });
    }
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
