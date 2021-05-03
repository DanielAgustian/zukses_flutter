class BussinessScopeModel {
  String name;
  int id;
  BussinessScopeModel({this.id, this.name});
  BussinessScopeModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['business_scope_name'];
  }
}
