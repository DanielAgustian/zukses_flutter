class LoginAPI {
  final String email;
  final String password;

  LoginAPI({this.email, this.password});
  factory LoginAPI.fromJson(Map<String, dynamic> json) {
    return LoginAPI(
      email: json['email'],
      password: json['password'],
    );
  }
}
