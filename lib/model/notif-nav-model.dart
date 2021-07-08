class NotifNavModel {
  int taskUnfinished;
  int meetingToday;

  NotifNavModel({this.taskUnfinished, this.meetingToday});

  factory NotifNavModel.fromJson(Map<String, dynamic> map) {
    return NotifNavModel(
        taskUnfinished: map['getAllUnfinished'],
        meetingToday: map['getAllSchedule']);
  }
}
