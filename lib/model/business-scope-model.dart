class BussinessScopeModel {
  String id, name;
  BussinessScopeModel({this.id, this.name});
  BussinessScopeModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }
}
