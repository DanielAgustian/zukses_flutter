class RegisterModel {
  String email;
  String username, password;

  RegisterModel({this.email, this.username, this.password});

  RegisterModel.fromJson(Map<String, dynamic> map) {
    this.email = map["email"];
    this.username = map["username"];
    this.password = map["password"];
  }
}
