import 'dart:convert';
import 'dart:io';
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
    print("UserProfile " + res.statusCode.toString());
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return UserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
      //throw Exception('Failed to load album');
    }
  }

  // get all employee data of the company
  Future<List<UserModel>> fetchEmployeeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.get(Uri.https(baseURI, 'api/all-user'),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("data user ${res.body}");
      var responseJson = jsonDecode(res.body);
      if (responseJson['user'] == null) {
        return null;
      }
      return (responseJson['user'] as List)
          .map((p) => UserModel.fromJson(p))
          .toList();
      //return AllUserModel.fromJson(jsonDecode(res.body)["user"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future<int> updateUserProfile(File image, String name, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String base64Image = base64Encode(image.readAsBytesSync());
    print(base64Image);
    print("Update Name: " + name);
    print("Update Phone: " + phone.toString());
    print(token);

    var res = await http.post(Uri.https(baseURI, 'api/edit-profile'),
        body: jsonEncode(<String, dynamic>{
          'image': base64Image,
          'name': name,
          'phone': phone
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return null;
    }
  }
}
