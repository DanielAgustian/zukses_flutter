import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/attendance-model.dart';

class AttendanceService {
  final baseURI = "api-zukses.yokesen.com/api";
  final fullBaseURI = "https://api-zukses.yokesen.com/api";
  // Clock in user
  Future<int> createClockIn(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String base64Image = base64Encode(image.readAsBytesSync());
    String imageName = image.path.split("/").last;
    print(token);
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

    // if success pas the attendance id
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      prefs.setInt("attendanceId", res["id"]);
      return res["id"];
    }
    return null;
  }

  // Get User attendance list
  Future<List<AttendanceModel>> getUserAttendaceList({DateTime date}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var month = date.month;
    var year = date.year;

    // get data
    var res = await http.get(fullBaseURI + "/user-attendance/$month/$year",
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $token'
        });

    if (res.statusCode == 200) {
      var jsonResult = jsonDecode(res.body);

      List<AttendanceModel> results = [];
      if (jsonResult["attendance"] != null) {
        jsonResult["attendance"].forEach((data) {
          results.add(AttendanceModel.fromJson(data));
        });
      }

      return results;
    } else {
      return null;
    }
  }
}
