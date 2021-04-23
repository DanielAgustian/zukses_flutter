class CheckListModel {
  String checkList;
  int id, taskId, userId;
  int status;
  CheckListModel(
      {this.checkList, this.id, this.taskId, this.userId, this.status});

  CheckListModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.taskId = map['task_id'];
    this.userId = map['user_id'];
    this.checkList = map['checklist'];
    this.status = map['status'];
  }
}
