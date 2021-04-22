import 'package:zukses_app_1/model/user-model.dart';

class CommentModel {
  String content;
  int id;
  DateTime date;
  UserModel user;
  CommentModel({this.id, this.content, this.date, this.user});
  CommentModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.content = map['content'];
    this.date = map['date'];
    this.user = UserModel.fromJson(map['user']);
  }
}
