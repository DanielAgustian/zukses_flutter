class MessageTypeModel {
  int id;
  String type;
  MessageTypeModel({this.id, this.type});

  factory MessageTypeModel.fromJson(Map<String, dynamic> map) {
    return MessageTypeModel(
        id: map['id'],
        type: map['type']);
  }
}
