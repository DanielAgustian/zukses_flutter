import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/invite-team-model.dart';
import 'package:zukses_app_1/model/register-model.dart';

class RegisterServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<int> createRegisterIndividual(RegisterModel regis) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/'),
      headers: <String, String>{},
      body: jsonEncode(<String, dynamic>{
        'email': regis.email,
        'username': regis.username,
        'password': regis.password
      }),
    );
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return null;
    }
  }

  Future<InviteTeamModel> createRegisterTeam(
      RegisterModel regis, String namaTeam) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/'),
      headers: <String, String>{},
      body: jsonEncode(<String, dynamic>{
        'email': regis.email,
        'username': regis.username,
        'password': regis.password,
        'namaTeam': namaTeam
      }),
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return InviteTeamModel.fromJson(jsonData);
    }else{
      return null;
    }
    
  }

  Future<int> createRegisterCompany(RegisterModel regis, String kode) async {
    final response = await http.post(
      Uri.https(baseURI, ''),
      headers: <String, String>{},
      body: jsonEncode(<String, dynamic>{
        'email': regis.email,
        'username': regis.username,
        'password': regis.password,
        'kode': kode
      }),
    );
    return response.statusCode;
  }
}
