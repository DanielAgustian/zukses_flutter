class LabelTaskModel {
  String name;
  int id;
  LabelTaskModel({this.id, this.name});
  LabelTaskModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}