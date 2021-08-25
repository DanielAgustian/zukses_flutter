import 'dart:convert';

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/comment-model.dart';

import 'package:http/http.dart' as http;

class CommentServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<CommentModel>> fetchComment(String idTask) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var queryParameters = {
      'taskId': idTask,
    };
    var res = await http.get(Uri.https(baseURI, 'api/comment', queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });
    print("fetch comment ${res.statusCode}");
    // print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var responseJson = jsonDecode(res.body);
      if (responseJson['Data'].toString() == "[]") {
        List<CommentModel> comment = [];
        return comment;
      }
      return (responseJson['Data'] as List)
          .map((p) => CommentModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      return null;
    }
  }

  Future<int> addComment(CommentModel comment) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/comment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'comment': comment.content,
          'taskId': comment.taskID
          //'userId': comment.user.userID,
        }));

    print("add comment ${res.statusCode}");

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

  Future<int> deleteComment(CommentModel comment) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.delete(Uri.https(baseURI, 'api/comment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'commentId': comment.id,
          //'userId': comment.user.userID,
        }));

    print("delete comment ${res.statusCode}");

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

  Future<int> updateComment(String commentId, String comment) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.put(Uri.https(baseURI, 'api/comment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'comment': comment,
          'commentId': commentId
          //'userId': comment.user.userID,
        }));

    print("update comment ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
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
