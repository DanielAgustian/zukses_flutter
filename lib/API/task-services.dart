import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/attachment-model.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:http/http.dart' as http;

class TaskServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<TaskModel>> fetchTask(int projectId) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var queryParameters = {
      'projectId': projectId.toString(),
    };

    var res = await http.get(Uri.https(baseURI, 'api/task', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });

    print("Fetch task ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      if (responseJson['Data'].toString() == "[]") {
        List<TaskModel> task;
        return task;
      } else {
        return (responseJson['Data'] as List)
            .map((p) => TaskModel.fromJson(p))
            .toList();
      }
    } else {
      // IF the server return everything except 200, it will gte exception.
      // print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> addTask(TaskModel task) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    //Query to API
    // print("Task Assginee" + task.assignee.toString());
    var res = await http.post(Uri.https(baseURI, '/api/task'),
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

    print("Add task ${res.statusCode}");
    print(res.body);
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

  Future<int> addTaskFree(TaskModel task) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
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
          'priority': task.priority,
          'dueDate': task.date.toString(),
          'notes': task.notes
        }));
    //print(res.body);
    print("Add task free ${res.statusCode}");

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

  Future<List<TaskModel>> fetchTaskByPriority(String priority) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("priority" + priority);
    //Query to API
    var queryParameters = {
      'priority': priority,
    };
    var res = await http.get(Uri.https(baseURI, 'api/task', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    //print(res.statusCode);
    //print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      if (responseJson['Data'].toString() == "[]") {
        List<TaskModel> task;
        return task;
      } else {
        return (responseJson['Data'] as List)
            .map((p) => TaskModel.fromJson(p))
            .toList();
      }
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> updateTask(
    TaskModel task,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.put(Uri.https(baseURI, 'api/task'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'taskId': task.idTask,
          'dueDate': task.date,
          'labelId': task.idLabel,
          'priority': task.priority
        }));
    print(res.statusCode);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,

      return res.statusCode;
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> changeProgressTask(String taskId, String progress) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.put(Uri.https(baseURI, 'api/task/progress'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
            <String, dynamic>{'taskId': taskId, 'progress': progress}));
    print(res.body);
    print(res.statusCode);
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

  Future<int> uploadAttachment(String taskId, File image) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String base64Image = base64Encode(image.readAsBytesSync());
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/attachment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
            <String, dynamic>{'taskId': taskId, 'image': base64Image}));

    print('Upload Attachment' + res.statusCode.toString());
    print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return res.statusCode;
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<List<AttachmentModel>> getAttachment(String taskId) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    //Query to API
    //
    var queryParameters = {
      'taskId': taskId,
    };
    var res = await http.get(
        Uri.https(baseURI, 'api/attachment', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });

    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      if (responseJson['Data'].toString() == "[]") {
        List<AttachmentModel> attach;
        return attach;
      } else {
        return (responseJson['Data'] as List)
            .map((p) => AttachmentModel.fromJson(p))
            .toList();
      }
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }
}
