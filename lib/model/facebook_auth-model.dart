import 'package:zukses_app_1/model/url-pic-model.dart';

class FBAuthModel {
  String email, name, id;
  UrlPicModel picture;
  FBAuthModel({this.email, this.name, this.id, this.picture});
  FBAuthModel.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.name = map['name'];
    this.id = map['id'];
    this.picture = UrlPicModel.fromJson(map['picture']['data']);
  }
}
