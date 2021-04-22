import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/company-model.dart';

class CompanyServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<CompanyModel> fetchCompanyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var res = await http
        .get(fullBaseURI + "/api/user-company", headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    });
    //print(res.statusCode.toString());
    //print(res.body);
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //print("response.body:" + response.body);
      var responseJson = jsonDecode(res.body);
      CompanyModel company = CompanyModel.fromJson(responseJson["company"]);
      return company;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<CompanyModel> fetchCompanyCode(String kode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var res = await http
        .get(fullBaseURI + "/api/company-code/$kode", headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      //'Authorization': 'Bearer $token'
    });
    //print(res.statusCode.toString());
    //print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //print("response.body:" + response.body);
      var responseJson = jsonDecode(res.body);

      final company = CompanyModel.fromJson(responseJson['company']);

      return company;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<int> addOrganization(
      CompanyModel company, String token, String scope) async {
    print("addOrganization ");
    var res = await http
        .post(fullBaseURI + "/api/organization", headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token'
    }, body: jsonEncode(<String, dynamic>{
      'legalName': company.name,
      'companyPhone': company.phone,
      'companyEmail': company.email,
      'companyWebsite': company.website,
      'companyAddress': company.address,
      'business_scope': scope,
      'package_id': company.packageId
    }));
    print(res.body);
    print(res.statusCode);
    return res.statusCode;
  }
}
