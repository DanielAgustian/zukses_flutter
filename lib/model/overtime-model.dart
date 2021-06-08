class OvertimeModel {
  /*DateTime clockIn, clockOut;
  String workingFrom, late, halfDay;*/
  String project, reason, status;
  int attendanceId;
  DateTime date;
  String startTime, endTime;
  OvertimeModel(
      {/*this.clockIn,
      this.clockOut,
      this.workingFrom,
      this.late,
      this.halfDay,*/
      this.date,
      this.startTime,
      this.endTime,
      this.attendanceId,
      this.project,
      this.reason,
      this.status});

  OvertimeModel.fromJson(Map<String, dynamic> map) {
    /*this.clockIn = DateTime.parse(map["clock_in_time"]);
    this.clockOut = map["clock_out_time"] == null
        ? DateTime.now()
        : DateTime.parse(map["clock_out_time"]);
    this.workingFrom = map["working_from"];
    this.late = map["late"];
    this.halfDay = map["half_day"];*/
    this.date = DateTime.parse(map["date"]);
    this.startTime = map["startTime"];
    this.endTime = map["endTime"];
    this.attendanceId =
        map["attendanceId"] == null ? null : map["attendanceId"];
    this.project = map["project"];
    this.reason = map["reason"];
    this.status = map["status"];
  }
}
