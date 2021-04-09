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

  Future createSchedule(String title, String description, DateTime date,
      String repeat, List<String> userID, DateTime meetingEndTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'date': date.toString(),
      'repeat': repeat,
      'userId': userID,
      'endTime': meetingEndTime.toString()
    };

    final response = await http.post(
      Uri.https(baseURI, '/api/schedule/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    print(response.statusCode.toString());
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      // Save token
      return response.statusCode;
    } else {
      // If the server did not return a 200 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');

      return null;
    }
  }

  Future<List<ScheduleModel>> fetchScheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, 'api/schedule/all/'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(res.body);
      //print(token);
      var responseJson = jsonDecode(res.body);

      return (responseJson['data'] as List)
          .map((p) => ScheduleModel.fromJson(p))
          .toList();
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<int> postDeleteSchedule(String meetingID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    final response = await http.post(
      Uri.https(baseURI, '/api/schedule/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'meetingId': meetingID,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      print("Data Error");
      return null;
    }
  }

  Future<int> postAcceptance(
      String meetingID, String accepted, String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.post(
      Uri.https(baseURI, '/api/schedule/response'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'meetingId': meetingID,
        'status': accepted,
        'rejectedReason': reason
      }),
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      //final schedule = ScheduleModel.fromJson(jsonDecode(response.body));
      // Save token
      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<ScheduleModel> fetchScheduleDetail(String meetingID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(
        Uri.https(baseURI, 'api/schedule/detail/$meetingID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseJson = jsonDecode(res.body);
      return ScheduleModel.fromJson(responseJson['data']);
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }

  Future<List<ScheduleModel>> fetchUnresponseScheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(Uri.https(baseURI, 'api/schedule/unresponse'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => ScheduleModel.fromJson(p))
          .toList();
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<ScheduleModel>> fetchRejectedScheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(Uri.https(baseURI, 'api/schedule/rejected'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => ScheduleModel.fromJson(p))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<ScheduleModel>> fetchAcceptedScheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(Uri.https(baseURI, 'api/schedule/accepted'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => ScheduleModel.fromJson(p))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<int> updateSchedule(
      String title,
      String description,
      DateTime date,
      String repeat,
      List<String> userID,
      String meetingId,
      DateTime endTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.post(
      Uri.https(baseURI, '/api/schedule/update'),
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
        'endTime': endTime.toString(),
        'userId': jsonEncode(userID),
        'meetingId': meetingId
      }),
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      final schedule = ScheduleModel.fromJson(jsonDecode(response.body));

      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }
}
