import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/label-task-model.dart';

class LabelTaskServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<LabelTaskModel>> fetchlabelTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, 'api/label'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    print(res.body);
    if (res.statusCode == 200) {
      var responseJson = jsonDecode(res.body);
      return (responseJson['Data'] as List)
          .map((p) => LabelTaskModel.fromJson(p))
          .toList();
    } else {
      return null;
    }
  }

  Future<int> createlabelTask(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.post(Uri.https(baseURI, 'api/label'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{'name': name}));
    print(res.body);
    print(res.statusCode);
    return res.statusCode;
  }
}
