class AttendanceModel {
  DateTime clockIn, clockOut;
  String isLate, id;
  String overtime;
  AttendanceModel({this.id, this.clockIn, this.clockOut, this.isLate});

  AttendanceModel.fromJson(Map<String, dynamic> map) {
    this.clockIn = DateTime.parse(map['clock_in_time']);
    this.clockOut = map['clock_out_time'] == null
        ? null
        : DateTime.parse(map['clock_out_time']);
    this.isLate = map['late'];
    this.id = map['id'].toString();
    this.overtime = map['minuteOvertime'];
  }
}
