import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }
}
