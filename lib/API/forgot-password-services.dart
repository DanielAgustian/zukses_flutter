import 'dart:convert';

import 'package:http/http.dart' as http;

class ForgotPasswordServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";

  Future<int> sentLinkToEmail(String email, String dynamicLink) async {
    print("Email" + email);
    print("link" + dynamicLink);
    var res = await http.post(Uri.https(baseURI, "/api/submit/forgot-email"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        },
        body:
            jsonEncode(<String, dynamic>{'email': email, 'link': dynamicLink}));
    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return null;
    }
  }

  Future<int> sentNewPassword(String password, String token) async {
    var res = await http.post(Uri.https(baseURI, "/api/submit/reset-pass"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          'password': password,
          'password_confirmation': password,
          'token': token
        }));
    print(res.body);
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return null;
    }
  }
}
