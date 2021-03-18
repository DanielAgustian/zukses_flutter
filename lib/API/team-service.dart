import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/team-model.dart';

class TeamServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<TeamModel>> fetchTeamMember() async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http
        .get(Uri.https(baseURI, 'api/team-status'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['attendance'] as List)
          .map((p) => TeamModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }
}