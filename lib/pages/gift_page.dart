import 'dart:io' show File;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gift_track/extensions/widget_extensions.dart';
import 'package:geolocator/geolocator.dart';
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
  late bool isNew;
  late bool purchased;
  late Gift gift;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  Position? position;

  @override
  void initState() {
    super.initState();

    getPermission().then((havePermission) async {
      if (havePermission) {
        var p = await Geolocator.getCurrentPosition();
        setState(() => position = p);
      }
    });

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
            if (position != null) buildMap(),
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

  Widget buildMap() {
    final latLng = LatLng(position!.latitude, position!.longitude);
    final cameraPosition = CameraPosition(
      target: latLng,
      zoom: 11.5, // max is usually 21
    );
    final marker = Marker(
      markerId: MarkerId('my-location'),
      position: latLng,
    );
    return SizedBox(
      //TODO: Cannot scroll on this because it is inside a ListView
      //TODO: which grabs all scrolling events.
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapToolbarEnabled: true,
        //mapType: MapType.hybrid,
        mapType: MapType.normal,
        //mapType: MapType.satellite,
        markers: {marker},
        myLocationEnabled: true,
        //myLocationButtonEnabled: true,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
      ),
      height: 200,
      width: double.infinity,
    );
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
