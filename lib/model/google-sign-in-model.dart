class GoogleSignInModel {
  String email, name, image;
  String token;
  GoogleSignInModel({this.email, this.name, this.image, this.token});
  GoogleSignInModel.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.name = map['name'];
    this.image = map['image'];
    this.token = map['token'];
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'image': image, 'token': token};
  }
}
