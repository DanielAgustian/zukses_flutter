import 'dart:convert';

import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:http/http.dart' as http;

class BusinessScopeServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<BussinessScopeModel>> fetchBusinessScope() async {
    var res =
        await http.get(Uri.https(baseURI, 'api/businessScope'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      
    });
    if (res.statusCode == 200) {
      var responseJson = jsonDecode(res.body);
      return (responseJson['businessScope'] as List)
          .map((p) => BussinessScopeModel.fromJson(p))
          .toList();
    } else {
      return null;
    }
  }
}
