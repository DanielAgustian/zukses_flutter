class NotifModel {
  int id, receiverId, slugId;
  String title, about;
  DateTime createdDate;
  NotifModel(
      {this.id,
      this.receiverId,
      this.slugId,
      this.title,
      this.about,
      this.createdDate});

  factory NotifModel.fromJson(Map<String, dynamic> map) {
    return NotifModel(
        id: map['id'],
        receiverId: map['receiver_id'],
        slugId: map["slug_id"],
        title: map["title"],
        about: map["about"],
        createdDate: DateTime.parse(map["created_at"]));
  }
}
