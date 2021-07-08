class ContactSupervisorListModel {
  String name;
  String photo;
  String about;
  DateTime time;
  int messageId;
  String status;
  ContactSupervisorListModel(
      {this.messageId,
      this.name,
      this.photo,
      this.about,
      this.time,
      this.status});
  ContactSupervisorListModel.fromJson(Map<String, dynamic> map) {
    this.messageId = map['messageId'];
    this.name = map['name'];
    this.photo = map['photo'] == null ? null : map['photo'];
    this.about = map['about'];
    this.time = DateTime.parse(map['time']);
    this.status = map['status'];
  }
}
