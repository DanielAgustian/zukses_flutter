class ContactSupervisorModel {
  String message;
  DateTime messageTime;
  int receiverId;
  int senderId, status;
  String about;

  ContactSupervisorModel(
      {this.message,
      this.messageTime,
      this.receiverId,
      this.senderId,
      this.about,
      this.status});
  ContactSupervisorModel.fromJson(Map<String, dynamic> map) {
    this.message = map['message'];
    this.messageTime = DateTime.parse(map['messageTime']);
    this.receiverId = map["receiver_id"];
    this.senderId = map["sender_id"];
    this.about = map["about"];
    this.status = map["status"];
  }
}
