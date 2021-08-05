import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/notif-model.dart';
import 'package:zukses_app_1/model/notif-nav-model.dart';

class NotifNavServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<NotifNavModel> fetchNotifNav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http.get(Uri.https(baseURI, 'api/project/all/unfinished'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $token'
          });

      print("Notif Nav label ${res.statusCode}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var responseJson = jsonDecode(res.body);

        return NotifNavModel.fromJson(responseJson);
      } else {
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }

  Future<List<NotifModel>> fetchNotifAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http
          .get(Uri.https(baseURI, 'api/all-notif'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      });

      print("Notif All label ${res.statusCode}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var responseJson = jsonDecode(res.body);

        return (responseJson['getNotif'] as List)
            .map((p) => NotifModel.fromJson(p))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }
}
