import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/overtime-model.dart';

class OvertimeServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<int> postOvertime(int attendanceId, String project, reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.post(
      Uri.https(baseURI, '/api/overtime'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'attendanceId': attendanceId.toString(), 'project': project, 'reason':reason}),
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("response.body:" + response.body);

      // Save token

      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }
  Future<List<OvertimeModel>> fetchOvertime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.get(
      Uri.https(baseURI, '/api/overtime'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      }
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("response.body:" + response.body);

      // Save token
      var responseJson = jsonDecode(response.body);
      print(responseJson);
      return (responseJson['data'] as List)
          .map((p) => OvertimeModel.fromJson(p))
          .toList();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }
}