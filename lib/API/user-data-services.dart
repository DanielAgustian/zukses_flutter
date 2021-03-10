import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/user-model.dart';

class UserDataServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";

  // get loggined user
  Future<UserModel> fetchUserProfile() async {
    //final response = await http.get(Uri.https(baseURI, 'api/user'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, 'api/user'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return UserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // get all employee data of the company
  Future<List<UserModel>> fetchEmployeeData() async {
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
      print("data user ${res.body}");
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
}
