import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:http/http.dart' as http;

class TaskServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<TaskModel>> fetchTask() async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http
        .get(Uri.https(baseURI, 'api/task'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => TaskModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> addTask(TaskModel task) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    List<String> data;

    print(task.assignee);
    var res = await http.post(Uri.https(baseURI, 'api/task'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'projectId': task.idProject,
          'title': task.taskName,
          'description': task.details,
          'assignTo': task.assignee,
          'priority': task.priority,
          'dueDate': task.date.toString(),
          'labelId': task.label,
          'notes': task.notes
        }));
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
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
}
