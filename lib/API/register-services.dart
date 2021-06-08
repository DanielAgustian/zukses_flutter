import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/auth-model.dart';

import 'package:zukses_app_1/model/register-model.dart';

class RegisterServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<AuthModel> createRegisterIndividual(RegisterModel regis,
      {String tokenFCM}) async {
    // print("email " + regis.email);
    // print("name " + regis.username);
    // print("password " + regis.password);
    // print("confirmPassowrd " + regis.confirmPassword);
    final response = await http.post(
      Uri.https(baseURI, '/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': regis.email,
        'name': regis.username,
        'password': regis.password,
        'password_confirmation': regis.confirmPassword,
        'fcmToken': tokenFCM
      }),
    );
    print("Register Individu:" + response.statusCode.toString());
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final user = AuthModel.fromJson(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      await prefs.setString("myID", user.user.userID);
      user.where = "individu";
      return user;
    } else {
      return null;
    }
  }

  Future<AuthModel> createRegisterTeamMember(
      RegisterModel regis, String link) async {
    // print("email " + regis.email);
    // print("name " + regis.username);
    // print("password " + regis.password);
    // print("confirmPassowrd " + regis.confirmPassword);
    final response = await http.post(
      Uri.https(baseURI, '/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': regis.email,
        'name': regis.username,
        'password': regis.password,
        'password_confirmation': regis.confirmPassword,
        'invitationLink': link
      }),
    );
    print("Register team member:" + response.statusCode.toString());
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final user = AuthModel.fromJson(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);

      user.where = "individu";
      return user;
    } else {
      return null;
    }
  }

  Future<int> createRegisterTeam(
      String token, String namaTeam, String link, List<String> email) async {
    /*String dynamicLink =
        await Util().createDynamicLink(short: false, page: "registerteam");
    print(dynamicLink);*/
    Map<String, dynamic> map = {
      'teamName': namaTeam,
      'invitationLink': link,
    };

    for (int i = 0; i < email.length; i++) {
      map['email${i + 1}'] = email[i];
    }
    // print(map);
    final response = await http.post(
      Uri.https(baseURI, '/api/team'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(map),
    );
    // print(response.body);
    print("Register team ${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.statusCode;
    } else {
      return null;
    }
  }

  Future<int> createRegisterToCompany(String token, String kode) async {
    //print("Auth.token = " + auth.token);
    print("Kode" + kode);
    final response = await http.post(
      Uri.https(baseURI, '/api/company-code'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{'companyCode': kode}),
    );
    // print(response.body);
    print("Register Company: " + response.statusCode.toString());
    return response.statusCode;
  }

  Future<int> postAcceptanceToCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String myID = prefs.getString("myID");
    final response = await http.post(
      Uri.https(baseURI, '/api/company/acceptance'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{'userId': myID}),
    );
    // print(response.body);
    print(response.statusCode);
    return response.statusCode;
  }
}
