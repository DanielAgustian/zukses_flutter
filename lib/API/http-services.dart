import 'dart:convert';
import 'dart:io';
//import 'package:zukses_api_1/API/post-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/login-api.dart';

class HttpService {
  //final String postsURL = "https://jsonplaceholder.typicode.com/posts";

  Future<LoginAPI> createLogin(String email, password) async {
    print(email);
    print(password);
    final response = await http.post(
      Uri.https('api-zukses.yokesen.com', '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("response.body:" + response.body);

      final user = LoginAPI.fromJson(jsonDecode(response.body));
      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = 1;
      await prefs.setString("token", user.token);

      return user;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  }

  Future<int> createClockIn(File image, String token) async {
    String base64Image = base64Encode(image.readAsBytesSync());
    String imageName = image.path.split("/").last;

    int code = 0;
    await http.post("https://api-zukses.yokesen.com/api/clock-in", body: {
      'image': base64Image,
    }, headers: <String, String>{
      'Authorization': 'Bearer $token'
    }).then((res) {
      print(res.body);
      print(res.statusCode);
      code = res.statusCode;
      return code;
    }).catchError((err) {
      print(err);
    });

    return code;
  }

  Future<int> createClockOut(String token) async {
    final response = await http.post(
      Uri.https('api-zukses.yokesen.com', '/api/clock-out'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
      body: jsonEncode(<String, dynamic>{}),
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }
}
