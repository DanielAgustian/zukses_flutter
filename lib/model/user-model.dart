class UserModel {
  String userID, name, email, phone, imgUrl, companyID, userIDSchedule;
  int accepted, companyAcceptance, notif;
  UserModel(
      {this.userID,
      this.name,
      this.email,
      this.imgUrl,
      this.phone,
      this.notif,
      this.companyID,
      this.accepted,
      this.userIDSchedule});

  Map<String, dynamic> toJson(UserModel user) {
    var map = Map<String, dynamic>();
    map["id"] = user.userID;
    map["email"] = user.email;
    map["name"] = user.name;
    map["company_id"] = user.companyID;
    map["image"] = user.imgUrl;
    map["accepted"] = user.accepted;
    map["companyAcceptance"] = user.companyAcceptance;
    return map;
  }

  UserModel.fromJson(Map<String, dynamic> map) {
    this.userID = map["id"].toString();
    this.userIDSchedule = map["userId"].toString();
    this.email = map["email"];
    this.name = map["name"];
    this.notif = map["notif"];
    this.imgUrl = map["image"] == null ? "" : map["image"];
    this.companyID =
        map["company_id"] == null ? "" : map["company_id"].toString();
    this.accepted = map["accepted"] == null ? 100 : map["accepted"];
    this.phone = map["mobile"] == null ? null : map["mobile"];
    this.companyAcceptance =
        map["companyAcceptance"] == null ? 100 : map["companyAcceptance"];
  }
}
