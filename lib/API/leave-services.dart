import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/leave-model.dart';

class LeaveServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<int> createLeave(
      int leaveTypeId, String duration, String leaveDate, String reason,
      [String startTime, String endTime, String leaveDateEnd]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    Map<String, dynamic> data = {
      'leaveTypeId': leaveTypeId,
      'duration': duration,
      'leaveDate': leaveDate,
      'reason': reason,
      'startTime': startTime == null ? "" : startTime,
      'endTime': endTime == null ? "" : endTime,
      'leaveDateEnd': leaveDateEnd == null ? "" : leaveDateEnd
    };
    final response = await http.post(
      Uri.https(baseURI, '/api/leave'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    print(response.statusCode.toString());
    //print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      //print("response.body:" + response.body);
      return response.statusCode;
    } else {
      return null;
    }
  }

  Future<List<LeaveModel>> fetchLeave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, 'api/leave'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => LeaveModel.fromJson(p))
          .toList();
    } else {
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }
}
