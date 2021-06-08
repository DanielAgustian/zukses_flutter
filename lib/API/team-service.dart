import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/team-detail-model.dart';
import 'package:zukses_app_1/model/team-model.dart';

class TeamServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<TeamModel>> fetchTeamMember() async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("Token = " + token);
    try {
      //Query to API
      var res = await http
          .get(Uri.https(baseURI, 'api/team-status'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      });

      print("Fetch team member" + res.statusCode.toString());

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var responseJson = jsonDecode(res.body);
        return (responseJson['attendance'] as List)
            .map((p) => TeamModel.fromJson(p))
            .toList();
      } else {
        // IF the server return everything except 200, it will gte exception.
        // print("Failed TO Load Alubm");
        return null;
        //throw Exception('Failed to load album');
      }
    } catch (excpetion) {
      return null;
    }
  }

  Future<TeamDetailModel> fetchDetailTeam(String id) async {
    var res = await http
        .get(Uri.https(baseURI, 'api/team/$id'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
    });
    print("Fetch detail team ${res.statusCode}");
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      final auth = TeamDetailModel.fromJson(data["team"]);
      return auth;
    } else {
      return null;
    }
  }
}
