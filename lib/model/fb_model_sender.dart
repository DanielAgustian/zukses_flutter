class FBModelSender {
  String email, name, id, url;

  FBModelSender({this.email, this.name, this.id,  this.url});
  FBModelSender.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.name = map['name'];
    this.id = map['id'];
    this.url = map['url'];
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'id': id,
      'url': url,
    };
  }
}
