import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class Util {
  static String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  String hourFormat(DateTime date) {
    //var now = new DateTime.now();
    //print(now.toString);
    String hour = "";
    if (date == null) {
      hour = DateFormat("HH:mm").format(DateTime.now());
    } else {
      hour = DateFormat("HH:mm").format(date);
    }
    return hour;
  }

  String yearFormat(DateTime date) {
    //var now = new DateTime.now();
    //print(now.toString);
    String year = "";
    if (date == null) {
      year = DateFormat("yyyy-MM-dd").format(DateTime.now());
    } else {
      year = DateFormat("yyyy-MM-dd").format(date);
    }
    return year;
  }

  String acceptancePrint(int num) {
    //num=100 merupakan NULL di DB
    if (num == 100) {
      return "pending";
    } else if (num == 0) {
      return "reject";
    } else if (num == 1) {
      return "accept";
    } else {
      return "Error";
    }
  }

  String changeTimeToString(TimeOfDay time) {
    String hour = "", minutes = "";
    if (time.hour < 10) {
      hour = "0" + time.hour.toString();
    } else {
      hour = time.hour.toString();
    }
    if (time.minute < 10) {
      minutes = "0" + time.minute.toString();
    } else {
      minutes = time.minute.toString();
    }
    return hour + ":" + minutes;
  }

  
  // void getLocationData() async {
  //   Location location = new Location();

  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   print(_locationData);
  //   print(_locationData.latitude);
  //   print(_locationData.longitude);
  // }

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
