import 'dart:convert';
//import 'package:zukses_api_1/API/post-model.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/API/login-api.dart';

class HttpService {
  //final String postsURL = "https://jsonplaceholder.typicode.com/posts";

  Future<LoginAPI> createLogin(String email, password) async {
    final response = await http.post(
      Uri.https('9ce5151ea12c.ngrok.io', '/api/login'),
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
      print(response.body);
      return LoginAPI.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  }
}
