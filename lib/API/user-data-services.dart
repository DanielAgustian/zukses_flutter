import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/user-model.dart';

class UserDataServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";

  Future<UserModel> fetchUserProfile() async {
    final response = await http.get(Uri.https(baseURI, 'api/user'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
