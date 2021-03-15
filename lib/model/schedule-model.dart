import 'package:zukses_app_1/model/user-model.dart';

class ScheduleModel {
  String meetingID, title, description, repeat, accepted, reason;
  DateTime date, meetingEndTime;
  List<UserModel> members;
  List<String> userID;

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
    this.meetingID = map["scheduleId"].toString() == null
        ? map["sheduleId"].toString()
        : map["scheduleId"].toString();
    this.title = map["title"];
    this.description = map["description"];
    this.date = DateTime.parse(map["date"]);

    this.meetingEndTime = DateTime.parse(map["meetingEndTime"]);

    this.repeat = map["repeat"];
    this.userID = map["userID"];
    this.accepted = map["accepted"].toString();
    this.reason = map["rejectedReason"];

    this.members = _convertMembers(map["members"]); //List<UserModel>
  }
  List<UserModel> _convertMembers(List membersMap) {
    if (membersMap == null) {
      return null;
    }
    List<UserModel> user = [];
    membersMap.forEach((value) {
      user.add(UserModel.fromJson(value));
    });

    return user;
  }
}
