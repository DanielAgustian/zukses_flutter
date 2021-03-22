

class LeaveTypeModel {
  int id;
  String typeName;

  LeaveTypeModel({this.id, this.typeName});

  LeaveTypeModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.typeName = map["type_name"];
  }
}
