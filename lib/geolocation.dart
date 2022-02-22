import 'package:geolocator/geolocator.dart';

Future<bool> getGeolocationPermission() async {
  // Test if location services are enabled.
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;
  // Consider asking user to enable location services.

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }

  return permission != LocationPermission.deniedForever;
}

Future<Position> getGeolocation() => Geolocator.getCurrentPosition();
