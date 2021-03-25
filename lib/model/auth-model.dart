import 'package:zukses_app_1/model/user-model.dart';

class AuthModel {
  String token;
  UserModel user;
  String attendance;
  String maxClockIn;
  AuthModel({this.token, this.user, this.attendance, this.maxClockIn});

  AuthModel.fromJson(Map<String, dynamic> map) {
    this.token = map["token"];
    this.user = UserModel.fromJson(map["user"]);
    this.attendance = map["attendance"].toLowerCase();
    this.maxClockIn = map["maxClockIn"].toLowerCase();
  }
}
