import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/invite-team-model.dart';
import 'package:zukses_app_1/model/register-model.dart';

class RegisterServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<AuthModel> createRegisterIndividual(RegisterModel regis) async {
    print("email " + regis.email);
    print("name " + regis.username);
    print("password " + regis.password);
    print("confirmPassowrd " + regis.confirmPassword);
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
        'password_confirmation': regis.confirmPassword
      }),
    );
    print("RegisterIndividu:" + response.statusCode.toString());
    print(response.body);
    if (response.statusCode == 201) {
      final user = AuthModel.fromJson(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      
      user.where = "individu";
      return user;
    } else {
      return null;
    }
  }

  Future<AuthModel> createRegisterTeam(
      RegisterModel regis, String namaTeam) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, dynamic>{
        'email': regis.email,
        'username': regis.username,
        'password': regis.password,
        'namaTeam': namaTeam
      }),
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AuthModel.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<int> createRegisterToCompany(RegisterModel regis, String kode) async {
    AuthModel auth = await createRegisterIndividual(regis);
    //print("Auth.token = " + auth.token);
    print("Kode" + kode);
    final response = await http.post(
      Uri.https(baseURI, '/api/company-code'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': 'Bearer ${auth.token}'
      },
      body: jsonEncode(<String, dynamic>{'companyCode': kode}),
    );
    print(response.body);
    print("Register COmpany" + response.statusCode.toString());
    return response.statusCode;
  }
}
