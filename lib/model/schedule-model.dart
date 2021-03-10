class ScheduleModel {
  String meetingID, title, description, date, repeat;
  List<String> userID;
  ScheduleModel(
      {this.meetingID,
      this.title,
      this.description,
      this.date,
      this.repeat,
      this.userID});

  Map<String, dynamic> toJson(ScheduleModel schedule) {
    var map = Map<String, dynamic>();
    map["id"] = schedule.meetingID;
    map["title"] = schedule.title;
    map["description"] = schedule.description;
    map["date"] = schedule.date;
    map["repeat"] = schedule.repeat;
    map["userID"] = schedule.userID;

    return map;
  }

  ScheduleModel.fromJson(Map<String, dynamic> map) {
    this.meetingID = map["id"].toString();
    this.title = map["title"];
    this.description = map["description"];
    this.date = map["date"].toString();
    this.repeat = map["repeat"];
    this.userID = map["userID"];
  }
}
