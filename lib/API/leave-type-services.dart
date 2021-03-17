import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
import 'package:http/http.dart' as http;
class LeaveTypeServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<LeaveTypeModel>> fetchLeaveType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(
        Uri.https(baseURI, 'api/leave-type'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(token);
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => LeaveTypeModel.fromJson(p))
          .toList();
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }
  
}