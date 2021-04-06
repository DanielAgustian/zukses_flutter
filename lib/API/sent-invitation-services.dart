import 'package:http/http.dart' as http;

class SentInvitationServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";

  Future<int> sentInviteByEmail(String email, String idTeam) async {
    var res = await http.post(Uri.https(baseURI, "/api/"),
        headers: <String, String>{},
        body: <String, dynamic>{'email': email, 'idTeam': idTeam});
    if (res.statusCode == 200) {
      return res.statusCode;
    } else {
      return 0;
    }
  }
}
