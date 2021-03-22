class LeaveModel {
  int id;
  String typeName, duration, leaveDate, startTime, endTime, reason, status;

  LeaveModel(
      {this.id,
      this.typeName,
      this.duration,
      this.leaveDate,
      this.startTime,
      this.endTime,
      this.reason,
      this.status});

  LeaveModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.typeName = map["type_name"];
    this.duration = map["duration"];
    this.leaveDate = map["leave_date"];
    this.startTime = map["startTime"];
    this.endTime = map["endTime"];
    this.reason = map["reason"];
    this.status = map["status"];
  }
}
