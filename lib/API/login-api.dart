class LoginAPI {
  final String email;
  final String password;
  final String token;
  LoginAPI({this.email, this.password, this.token});
  factory LoginAPI.fromJson(Map<String, dynamic> json) {
    return LoginAPI(
        email: json['email'], password: json['password'], token: json['token']);
  }
}
