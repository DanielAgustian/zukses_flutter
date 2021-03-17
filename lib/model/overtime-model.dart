class OvertimeModel {
  DateTime clockIn, clockOut;
  String workingFrom, late, halfDay, project, reason;
  int attendanceId;

  OvertimeModel(
      {this.clockIn,
      this.clockOut,
      this.workingFrom,
      this.late,
      this.halfDay,
      this.attendanceId,
      this.project,
      this.reason});

  OvertimeModel.fromJson(Map<String, dynamic> map) {
    this.clockIn = DateTime.parse(map["clock_in_time"]);
    this.clockOut = DateTime.parse(map["clock_out_time"]);
    this.workingFrom = map["working_from"];
    this.late = map["late"];
    this.halfDay = map["half_day"];
    this.attendanceId = map["attendanceId"];
    this.project = map["project"];
    this.reason = map["reason"];
  }
}
