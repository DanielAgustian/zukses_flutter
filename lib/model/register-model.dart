class RegisterModel {
  String email;
  String username, password, confirmPassword;

  RegisterModel({this.email, this.username, this.password, this.confirmPassword});

  RegisterModel.fromJson(Map<String, dynamic> map) {
    this.email = map["email"];
    this.username = map["username"];
    this.password = map["password"];
    
  }
}
