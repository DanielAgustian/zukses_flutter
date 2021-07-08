class AdminModel {
  int id;
  String name;
  String email;
  AdminModel({this.id, this.name, this.email});

  AdminModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.email = map["email"];
  }
}
