import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/message-type-model.dart';

class MessageTypeServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<MessageTypeModel>> fetchMessageType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http.get(Uri.https(baseURI, 'api/message-type'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $token'
          });

      print("fetch message type label ${res.statusCode}");
     
      if (res.statusCode >= 200 && res.statusCode < 300) {
        var responseJson = jsonDecode(res.body);

        return (responseJson['getType'] as List)
          .map((p) => MessageTypeModel.fromJson(p))
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
