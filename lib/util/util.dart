import 'package:intl/intl.dart';

class Util {
  static String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }
}
