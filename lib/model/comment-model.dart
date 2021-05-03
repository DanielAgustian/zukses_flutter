

class CommentModel {
  String content;
  int taskID;
  int id, userId;
  DateTime date;

  String nameUser;
  CommentModel(
      {this.id,
      this.content,
      this.date,
      this.taskID,
      this.nameUser,
      this.userId});
  CommentModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.content = map['comment'];
    this.date = DateTime.parse(map['updated_at']);
    //this.user = UserModel.fromJson(map['user']);
    this.taskID = map['task_id'];
    this.nameUser = map['name'];
    this.userId = map['user_id'];
  }
}
