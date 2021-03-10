import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:http/http.dart' as http;

class MeetingServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  Future<List<UserModel>> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, 'api/all-user'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(res.body);
      var responseJson = jsonDecode(res.body);
      return (responseJson['user'] as List)
          .map((p) => UserModel.fromJson(p))
          .toList();
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ScheduleModel> createSchedule(String title, String description,
      DateTime date, String repeat, List<String> userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.post(
      Uri.https(baseURI, '/api/schedule/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'date': date.toString(),
        'repeat': repeat,
        'userId': jsonEncode(userID)
      }),
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("response.body:" + response.body);

      final schedule = ScheduleModel.fromJson(jsonDecode(response.body));
      // Save token
      return schedule;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }
}
