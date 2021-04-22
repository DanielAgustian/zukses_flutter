import 'dart:convert';

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/comment-model.dart';

import 'package:http/http.dart' as http;

class CommentServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<CommentModel>> fetchComment() async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http
        .get(Uri.https(baseURI, 'api/Comment'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    } );

    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['data'] as List)
          .map((p) => CommentModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }

  Future<int> addComment(CommentModel comment, File image) async {
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
          'content': comment.content,
          //'userId': comment.user.userID,
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

  Future<int> deleteComment(CommentModel comment) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/comment/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'id': comment.id,
          //'userId': comment.user.userID,
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

  Future<int> updateComment(CommentModel comment, File image) async {
    //Token from Login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    //Query to API
    var res = await http.post(Uri.https(baseURI, 'api/comment/update'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'content': comment.content,
          //'userId': comment.user.userID,
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
