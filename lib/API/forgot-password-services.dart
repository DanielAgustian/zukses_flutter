import 'package:http/http.dart' as http;

class ForgotPasswordServicesHTTP {
  final baseURI = "api-zukses.yokesen.com";

  Future<int> sentLinkToEmail(String email) async {
    var res = await http.post(Uri.https(baseURI, "/api/"),
        headers: <String, String>{}, body: <String, dynamic>{'email': email});
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return null;
    }
  }
  Future<int> sentNewPassword(String password) async {
    var res = await http.post(Uri.https(baseURI, "/api/"),
        headers: <String, String>{}, body: <String, dynamic>{'password': password});
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return null;
    }
  }
}
