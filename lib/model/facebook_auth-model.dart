import 'package:zukses_app_1/model/url-pic-model.dart';

class FBAuthModel {
  String email, name, id, url;
  UrlPicModel picture;
  FBAuthModel({this.email, this.name, this.id, this.picture, this.url});
  FBAuthModel.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.name = map['name'];
    this.id = map['id'];
    this.picture = UrlPicModel.fromJson(map['picture']['data']);
    
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'id': id, 'picture': picture.toJson()};
  }
}
