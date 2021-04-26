import 'package:zukses_app_1/model/assignment-mode.dart';
import 'package:zukses_app_1/model/user-model.dart';

class TaskModel {
  int idTask, idProject, idLabel;
  String taskName, details;
  UserModel reporter;
  List<int> assignee;
  List<AssignmentModel> assignment;
  String date;
  String taskType, label, priority, attachmentUrl, idComment;
  String notes;
  TaskModel(
      {this.idTask,
      this.idProject,
      this.idLabel,
      this.taskName,
      this.details,
      this.reporter,
      this.assignee,
      this.date,
      this.taskType,
      this.label,
      this.priority,
      this.attachmentUrl,
      this.idComment,
      this.assignment,
      this.notes});
  TaskModel.fromJson(Map<String, dynamic> map) {
    this.idTask = map["id"];
    this.idProject = map["projectId"];
    this.taskName = map["title"];
    this.details = map["description"];
    this.reporter = map["reporter"] == null
        ? UserModel()
        : UserModel.fromJson(map['reporter']);
    this.assignee = map["assignee"];
    this.date = map["due_date"] == null ? "" : map["due_date"];
    this.taskType = map["progress"];
    this.idLabel = map["label_id"];
    this.label = map["labelsName"];
    this.priority = map["priority"];
    this.attachmentUrl = map["attachmentUrl"];
    this.notes = map["notes"];
    this.assignment = _convertMembers(map['assignment']);
  }

  List<AssignmentModel> _convertMembers(List membersMap) {
    if (membersMap == null) {
      return null;
    }
    List<AssignmentModel> user = [];
    membersMap.forEach((value) {
      user.add(AssignmentModel.fromJson(value));
    });

    return user;
  }
}
