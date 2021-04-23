import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/checklist-model.dart';
import 'package:http/http.dart' as http;

class CheckListTaskService {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<CheckListModel> addCheckList(
      String taskId, String checkListName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.post(Uri.https(baseURI, 'api/checklist'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
            <String, dynamic>{'taskId': taskId, 'checklist': checkListName}));
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      var responseJson = jsonDecode(res.body);
      CheckListModel model = CheckListModel.fromJson(responseJson['Data']);
      return model;
    } else {
      return null;
    }
  }

  Future<CheckListModel> putCheckList(String idCheckList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http.put(Uri.https(baseURI, 'api/checklist'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'checklistId': idCheckList}));

    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var responseJson = jsonDecode(res.body);
      CheckListModel model = CheckListModel.fromJson(responseJson['Data']);
      return model;
    } else {
      return null;
    }
  }

  Future<List<CheckListModel>> getCheckList(String taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var queryParameters = {
      'taskId': taskId,
    };
    var res = await http.get(
      Uri.https(baseURI, 'api/checklist', queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var responseJson = jsonDecode(res.body);
      if (responseJson['Data'].toString() == "[]") {
        List<CheckListModel> model = [];
        return model;
      }
      return (responseJson['Data'] as List)
          .map((p) => CheckListModel.fromJson(p))
          .toList();
    } else {
      return null;
    }
  }
}
