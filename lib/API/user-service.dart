import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:http/http.dart' as http;

class UserServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  // Get User data
  Future<UserModel> getUserData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    //LOGIC
    // provide params for url
    var params = {"id": id};

    //add params to url
    Uri url = Uri.parse(fullBaseURI);
    final paramsURI = url.replace(queryParameters: params);

    // get data
    var res = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });

    if (res.statusCode == 200) {
      print("User : ${res.body}");

      UserModel _userModel = UserModel.fromJson(jsonDecode(res.body));
      return _userModel;
    } else {
      return null;
    }
  }
}
