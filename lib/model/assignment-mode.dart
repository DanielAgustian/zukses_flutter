class AssignmentModel {
  String userID, name, companyID, taskID;

  AssignmentModel({
    this.userID,
    this.name,
    this.taskID,
    this.companyID,
  });

  AssignmentModel.fromJson(Map<String, dynamic> map) {
    this.userID = map["user_id"].toString();
    this.taskID = map['task_id'].toString();

    this.name = map["name"];

    this.companyID = map["company_id"].toString();
  }
}
