import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  // create a location varibale
  late Location _location;

  //create a getter so that its not exposed
  Location get location => _location;

  LatLng _locationPosition = LatLng(35.7484937, 139.8063315);

  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;
  LocationProvider() {
    _location = new Location();
  }
  initialization() async {
    getuserLocation();
  }

  getuserLocation() async {
    bool _serviceenabled;
    PermissionStatus _permissionGranted;
    //  check if user is having permission or not
    _serviceenabled = await location.serviceEnabled();

    if (!_serviceenabled) {
      _serviceenabled = await location.requestService();

      if (!_serviceenabled) return;
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted == PermissionStatus.granted ||
          _permissionGranted == PermissionStatus.grantedLimited) return;
    }
    location.onLocationChanged.listen((LocationData currentlocation) {
      _locationPosition = LatLng(
        currentlocation.latitude!.toDouble(),
        currentlocation.longitude!.toDouble(),
      );
    });
    // print(_locationPosition);
    notifyListeners();
  }
}
