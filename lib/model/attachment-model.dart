class AttachmentModel {
  int id;
  String attachment;
  AttachmentModel({this.id, this.attachment});
  AttachmentModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.attachment = map["attachment"];
  }
}
