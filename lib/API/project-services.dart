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

    print("Fetch project ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
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
    String base64Image;
    var jsonData;

    // print(image.path);
    if (image.path.length > 0) {
      base64Image = base64Encode(image.readAsBytesSync());
      jsonData = jsonEncode(<String, dynamic>{
        'projectName': project.name,
        'projectKey': project.details,
        'image': base64Image
      });
    } else {
      jsonData = jsonEncode(<String, dynamic>{
        'projectName': project.name,
        'projectKey': project.details,
      });
    }

    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/project'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonData);
    // print(res.body);

    print("Add project ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //var responseJson = jsonDecode(res.body);
      return res.statusCode;
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> bookmarkProject(String projectId) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var jsonData = jsonEncode(<String, dynamic>{
      'projectId': projectId,
    });
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/bookmark'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonData);
    // print(res.body);
    print("bookmark project ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return res.statusCode;
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed to bookmarked this project");
      return null;
    }
  }
}
