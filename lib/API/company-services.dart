import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/admin-model.dart';
import 'package:zukses_app_1/model/company-model.dart';

class CompanyServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<CompanyModel> fetchCompanyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(Uri.https(baseURI, "/api/user-company"), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });

    print("Fetch company profile " + res.statusCode.toString());
    //print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 201 CREATED res,
      // then parse the JSON.
      //print("res.body:" + res.body);
      var resJson = jsonDecode(res.body);
      CompanyModel company = CompanyModel.fromJson(resJson["company"]);
      return company;
    } else {
      // If the server did not return a 201 CREATED res,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<CompanyModel> fetchCompanyCode(String kode) async {
    var res = await http.get(Uri.https(baseURI, "/api/company-code/$kode"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        });

    print("fetch company code " + res.statusCode.toString());
    //print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // If the server did return a 200 OK res,
      // then parse the JSON.

      var resJson = jsonDecode(res.body);

      final company = CompanyModel.fromJson(resJson['company']);

      return company;
    } else {
      // If the server did not return a 201 CREATED res,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<int> addOrganization(
      CompanyModel company, String token, String scope) async {
    print("addOrganization ");
    try {
      var res = await http.post(Uri.https(baseURI, "/api/organization"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'legalName': company.name,
            'companyPhone': company.phone,
            'companyEmail': company.email,
            'companyWebsite': company.website,
            'companyAddress': company.address,
            'business_scope': scope,
            'package_id': company.packageId
          }));
      // print(res.body);
      print(res.statusCode);
      return res.statusCode;
    } catch (e) {
      return 0;
    }
  }

  Future<List<AdminModel>> fetchAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    try {
      var res = await http.get(
        Uri.https(baseURI, "/api/user/admin"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        },
      );
      // print(res.body);
      print("Fetch Admin${res.statusCode}");
      var responseJson = jsonDecode(res.body);
      return (responseJson['getAdmin'] as List)
          .map((p) => AdminModel.fromJson(p))
          .toList();
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
