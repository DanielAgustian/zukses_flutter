class UserModel {
  String userID, name, email, phone, imgUrl;

  UserModel({this.userID, this.name, this.email, this.phone, this.imgUrl});

  UserModel.toJson(Map<String, dynamic> map) {
    this.userID = map["id"];
    this.email = map["email"];
    this.name = map["name"]; 
    this.phone = map["phone"];  
    this.imgUrl = map["imgUrl"]; 
  }
}
