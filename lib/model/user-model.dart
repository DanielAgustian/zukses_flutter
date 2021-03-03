class UserModel {
  String userID, name, email, phone, imgUrl, companyID;

  UserModel({this.userID, this.name, this.email, this.imgUrl, this.companyID});

  Map<String, dynamic> toJson(UserModel user) {
    var map = Map<String, dynamic>();
    map["id"] = user.userID;
    map["email"] = user.email;
    map["name"] = user.name;
    map["company_id"] = user.companyID;
    map["imgUrl"] = user.imgUrl;

    return map;
  }

  UserModel.fromJson(Map<String, dynamic> map) {
    this.userID = map["id"];
    this.email = map["email"];
    this.name = map["name"];
    this.imgUrl = map["imgUrl"] == null ? "" : map["imgUrl"];
    this.companyID = map["company_id"];
  }
}
