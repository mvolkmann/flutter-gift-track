import 'dart:async' show Completer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show FloatingActionButton, Icons;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/my_button.dart';

class MyMap extends StatefulWidget {
  final LatLng location;
  final double initialZoom;
  final VoidCallback onCleared;
  final void Function(LatLng) onLocationChanged;
  final void Function(double) onZoomChanged;

  MyMap({
    Key? key,
    required this.location,
    required this.initialZoom,
    required this.onCleared,
    required this.onLocationChanged,
    required this.onZoomChanged,
  }) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late double zoom;
  late CameraPosition cameraPosition;
  late Marker marker;

  // This allows the GoogleMap widget to process gestures for
  final gestureRecognizers = {
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  final mapControllerCompleter = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    zoom = widget.initialZoom;
    cameraPosition = CameraPosition(target: widget.location, zoom: zoom);
    marker =
        Marker(markerId: MarkerId('my-location'), position: widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          GoogleMap(
            gestureRecognizers: gestureRecognizers,
            initialCameraPosition: cameraPosition,
            //TODO: What do these commented-out options do?
            //mapToolbarEnabled: true,
            //mapType: MapType.hybrid,
            mapType: MapType.normal,
            //mapType: MapType.satellite,
            markers: {marker},
            //myLocationEnabled: true,
            myLocationButtonEnabled: false, // hides provided lower-right button
            onMapCreated: (GoogleMapController controller) {
              mapControllerCompleter.complete(controller);
            },
            onCameraMove: (position) {
              if (position.zoom == zoom) {
                widget.onLocationChanged(position.target);
              } else {
                if (position.zoom % 1 == 0) {
                  changeZoom(position.zoom);
                }
              }
            },
            //scrollGesturesEnabled: true,
            //zoomControlsEnabled: true,
            //zoomGesturesEnabled: true,
          ),
          Positioned(
            child: MyButton(
                icon: CupertinoIcons.clear, onPressed: widget.onCleared),
            top: 0,
            right: 0,
          ),
          Positioned(
            child: FloatingActionButton.small(
              child: Icon(Icons.add),
              heroTag: 'gift-page-zoom-in',
              onPressed: () => changeZoom(zoom + 1),
            ),
            bottom: 45,
            right: 0,
          ),
          Positioned(
            child: FloatingActionButton.small(
              child: Icon(Icons.remove),
              heroTag: 'gift-page-zoom-ou',
              onPressed: () => changeZoom(zoom - 1),
            ),
            bottom: 0,
            right: 0,
          ),
        ],
      ),
      height: 200,
      width: double.infinity,
    );
  }

  void changeZoom(double newZoom) async {
    setState(() => zoom = newZoom);
    final controller = await mapControllerCompleter.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: widget.location, zoom: newZoom)));
    widget.onZoomChanged(zoom);
  }
}
