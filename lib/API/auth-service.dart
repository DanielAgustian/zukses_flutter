import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:http/http.dart' as http;

class AuthServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<AuthModel> createLogin(String email, password) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/login'),
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

      final user = AuthModel.fromJson(jsonDecode(response.body));

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);

      return user;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }
}
