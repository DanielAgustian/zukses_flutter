import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/user-model.dart';

class UserDataServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";

  Future<UserModel> fetchUserProfile() async {
    final response = await http.get(Uri.https(baseURI, 'api/user'));

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
