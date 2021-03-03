import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  // Clock in user
  Future<int> createClockIn(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String base64Image = base64Encode(image.readAsBytesSync());
    String imageName = image.path.split("/").last;

    int code = 0;
    await http.post("https://api-zukses.yokesen.com/api/clock-in", body: {
      'image': base64Image,
    }, headers: <String, String>{
      'Authorization': 'Bearer $token'
    }).then((res) {
      print(res.body);
      print(res.statusCode);
      code = res.statusCode;
      return code;
    }).catchError((err) {
      print(err);
    });

    return code;
  }

  // CLock out user
  Future<int> createClockOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.post(
      Uri.https('api-zukses.yokesen.com', '/api/clock-out'),
      headers: <String, String>{'Authorization': 'Bearer $token'},
      body: jsonEncode(<String, dynamic>{}),
    );
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }
}
