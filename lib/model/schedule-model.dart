import 'package:zukses_app_1/model/user-model.dart';

class ScheduleModel {
  String meetingID, title, description, repeat, accepted, reason;
  DateTime date, meetingEndTime;
  List<String> userID;
  List<UserModel> members;
  //String status;
  ScheduleModel(
      {this.meetingID,
      this.title,
      this.description,
      this.date,
      this.repeat,
      this.meetingEndTime,
      this.userID,
      this.accepted,
      this.reason});

  Map<String, dynamic> toJson(ScheduleModel schedule) {
    var map = Map<String, dynamic>();
    map["scheduleId"] = schedule.meetingID;
    map["title"] = schedule.title;
    map["description"] = schedule.description;
    map["date"] = schedule.date;
    map["repeat"] = schedule.repeat;
    map["endTime"] = schedule.meetingEndTime;
    map["userID"] = schedule.userID;
    map["accepted"] = schedule.accepted;
    map["rejectedReason"] = schedule.reason;
    map["members"] = schedule.members;
    return map;
  }

  ScheduleModel.fromJson(Map<String, dynamic> map) {
    this.meetingID = map["scheduleId"].toString();
    this.title = map["title"];
    this.description = map["description"];
    this.date = map["date"];
    this.meetingEndTime = map["endTime"];
    this.repeat = map["repeat"];
    this.userID = map["userID"];
    this.accepted = map["accepted"];
    this.reason = map["rejectedReason"];
    this.members = map["members"];
  }
}
