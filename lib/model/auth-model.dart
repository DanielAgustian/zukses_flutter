import 'package:zukses_app_1/model/user-model.dart';

class AuthModel {
  String token;
  UserModel user;
  String attendance;
  String maxClockIn;
  String where;
  AuthModel(
      {this.token, this.user, this.attendance, this.maxClockIn, this.where});

  AuthModel.fromJson(Map<String, dynamic> map) {
    this.token = map["token"];
    this.user = UserModel.fromJson(map["user"]);

    this.attendance =
        map["attendance"] == null ? "" : map["attendance"].toLowerCase();
    this.maxClockIn =
        map["maxClockIn"] == null ? "" : map["maxClockIn"].toLowerCase();
  }
}
