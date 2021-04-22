class TaskModel {
  int idTask, idProject;
  String taskName, details, reporter;
  List<int> assignee;
  DateTime date;
  String taskType, label, priority, attachmentUrl, idComment;
  String notes;
  TaskModel(
      {this.idTask,
      this.idProject,
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
      this.notes});
  TaskModel.fromJson(Map<String, dynamic> map) {
    this.idTask = map["id"];
    this.idProject = map["projectId"];
    this.taskName = map["name"];
    this.details = map["details"];
    this.reporter = map["reporter"];
    this.assignee = map["assignee"];
    this.date = map["date"];
    this.taskType = map["taskType"];
    this.label = map["label"];
    this.priority = map["priority"];
    this.attachmentUrl = map["attachmentUrl"];
    this.notes = map["notes"];
  }
}
