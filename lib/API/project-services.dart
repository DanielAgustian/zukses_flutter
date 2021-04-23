import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/project-model.dart';

class ProjectServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<ProjectModel>> fetchProject() async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http
        .get(Uri.https(baseURI, 'api/project'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(res.body);
      var responseJson = jsonDecode(res.body);
      if (responseJson['data'].toString() == "[]") {
        List<ProjectModel> project;
        return project;
      }
      return (responseJson['data'] as List)
          .map((p) => ProjectModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }

  Future<int> addProject(ProjectModel project, File image) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String base64Image = base64Encode(image.readAsBytesSync());
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/project'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'projectName': project.name,
          'projectKey': project.details,
          'image': base64Image
        }));

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //var responseJson = jsonDecode(res.body);
      return res.statusCode;
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }
}
