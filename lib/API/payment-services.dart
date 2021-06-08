import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/payment-model.dart';

class PaymentServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<String> sentPaymentData(PaymentModel payment) async {
    var res = await http.post(Uri.https(baseURI, "/api/"),
        headers: <String, String>{},
        body: <String, dynamic>{
          'cardNumber': payment.cardNumber,
          'cardName': payment.cardName,
          'mmyy': payment.mmyy,
          'cvc': payment.cvc,
          'address': payment.address,
          'country': payment.country,
          'city': payment.city,
          'province': payment.province,
          'zipCode': payment.zipCode
        });

    print("send payment data ${res.statusCode}");

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var jsonData = jsonDecode(res.body);
      return jsonData['statusBayar'];
    } else {
      return null;
    }
  }
}
