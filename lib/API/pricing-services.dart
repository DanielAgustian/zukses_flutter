import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/pricing-model.dart';

class PricingServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<List<PricingModel>> fetchPricing() async {
    //Query to API
    var res = await http
        .get(Uri.https(baseURI, 'api/plans'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
    });
    if (res.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var responseJson = jsonDecode(res.body);
      return (responseJson['plans'] as List)
          .map((p) => PricingModel.fromJson(p))
          .toList();
    } else {
      // IF the server return everything except 200, it will gte exception.
      print("Failed TO Load Alubm");
      throw Exception('Failed to load album');
    }
  }
}
