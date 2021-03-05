import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:location/location.dart';

class Util {
  static String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  void getLocationData() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    print(_locationData.latitude);
    print(_locationData.longitude);
  }

  void showToast(
      {BuildContext context,
      String msg,
      int duration,
      Color color,
      Color txtColor}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        textColor: txtColor);
  }
}
