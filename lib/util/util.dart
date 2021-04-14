import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Util {
  String getHourNow() {
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

  TimeOfDay stringToTimeOfDay(String tod) {
    return TimeOfDay(
        hour: int.parse(tod.split(":")[0]),
        minute: int.parse(tod.split(":")[1]));
  }

  String dateNumbertoCalendar(DateTime date) {
    return DateFormat('yMMMd').format(date);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  saveSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> createDynamicLink(
      {bool short, String value, String key, String page}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse('https://zuksesapplication.page.link/$page?'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.zukses_app_1',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
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
