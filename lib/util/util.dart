import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class Util {
  static String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
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
