import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/contact-supervisor-modal.dart';
import 'package:zukses_app_1/model/list-contact-spv-model.dart';
import 'package:zukses_app_1/model/message-type-model.dart';

class ContactSupervisorServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<int> createContactSupervisor(
      String message, String typeId, String about, String receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http.post(Uri.https(baseURI, 'api/contact-supervisor'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'message': message,
            'type_id': typeId,
            'about': about,
            'receiver_id': receiverId
          }));

      print("Create Contact Supervisor label ${res.statusCode}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res.statusCode;
      } else {
        return 0;
      }
    } catch (e) {
      print("Error : $e");
      return 0;
    }
  }

  Future<List<ContactSupervisorModel>> getContactSupervisor(
      String conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http.get(
        Uri.https(baseURI, 'api/contact-supervisor/$conversationId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      print("Get Contact Supervisor label ${res.statusCode}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var responseJson = jsonDecode(res.body);
        return (responseJson['getAllMessage'] as List)
            .map((p) => ContactSupervisorModel.fromJson(p))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }

  Future<int> answerContactSupervisor(
      String messageId, String message, String receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    final queryParameters = {
      'messageId': messageId,
    };
    try {
      var res = await http.post(
          Uri.https(baseURI, 'api/contact-supervisor', queryParameters),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
              <String, String>{'message': message, 'receiver_id': receiverId}));

      print("Answer Contact Supervisor label ${res.statusCode}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res.statusCode;
      } else {
        return 0;
      }
    } catch (e) {
      print("Error : $e");
      return 0;
    }
  }

  Future<List<ContactSupervisorListModel>> getContactSupervisorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      var res = await http.get(
        Uri.https(baseURI, 'api/getMessageSupervisor'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
      );

      print("Get Contact Supervisor List label ${res.statusCode}");
      print(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        var responseJson = jsonDecode(res.body);
        return (responseJson['data'] as List)
            .map((p) => ContactSupervisorListModel.fromJson(p))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }
}
