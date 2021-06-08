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
    print("User Profile " + res.statusCode.toString());
    // print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
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
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print("data user ${res.body}");
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

  Future<int> updateUserProfile(
      File image, String name, String phone, String link) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var jsonData;
    if (image != null) {
      //Sent Image
      String base64Image = base64Encode(image.readAsBytesSync());
      // print(base64Image);
      jsonData = jsonEncode(<String, dynamic>{
        'image': base64Image,
        'name': name,
        'phone': phone
      });
    } else {
      if (link == null || link == "") {
        //Sent Empty Image or Delete Pic
        jsonData = jsonEncode(<String, dynamic>{'name': name, 'phone': phone});
      } else {
        //The Image on Database will stay
        jsonData = jsonEncode(
            <String, dynamic>{'image': link, 'name': name, 'phone': phone});
      }
    }

    // print("Update Name: " + name);
    // print("Update Phone: " + phone.toString());
    // print(token);

    var res = await http.post(Uri.https(baseURI, 'api/edit-profile'),
        body: jsonData,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print(res.statusCode);
    // print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.statusCode;
    } else {
      return null;
    }
  }

  // Change user notification
  Future<String> changeNotificationStatus(int status) async {
    //final response = await http.get(Uri.https(baseURI, 'api/user'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var res = await http.post(Uri.https(baseURI, 'api/notif'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{"notif": status}));

    print("change notification status " + res.statusCode.toString());
    // print(res.body);
    String msg = "";

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonResult = jsonDecode(res.body);

      msg = jsonResult["Message"];
      return msg;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return msg;
    }
  }
}
