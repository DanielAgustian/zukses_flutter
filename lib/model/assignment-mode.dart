class AssignmentModel {
  String userID, name, companyID, taskID, imgUrl;

  AssignmentModel(
      {this.userID, this.name, this.taskID, this.companyID, this.imgUrl});

  AssignmentModel.fromJson(Map<String, dynamic> map) {
    this.userID = map["user_id"].toString();
    this.taskID = map['task_id'].toString();

    this.name = map["name"];

    this.companyID = map["company_id"].toString();
    this.imgUrl = map["userPhoto"] == null ? null : map["userPhoto"];
  }
}
