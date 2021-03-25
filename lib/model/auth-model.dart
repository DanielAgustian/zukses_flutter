import 'package:zukses_app_1/model/user-model.dart';

class AuthModel {
  String token;
  UserModel user;
  String attendance;
  AuthModel({this.token, this.user, this.attendance});

  AuthModel.fromJson(Map<String, dynamic> map) {
    this.token = map["token"];
    this.user = UserModel.fromJson(map["user"]);
    this.attendance = map["attendance"];
  }
}
