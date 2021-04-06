class TeamModel {
  int userId;
  String name, email, imgUrl, late;
  DateTime clockIn, clockOut;
  
  TeamModel(
      {this.userId,
      this.name,
      this.imgUrl,
      this.clockIn,
      this.clockOut,
      this.late});

  TeamModel.fromJson(Map<String, dynamic> map) {
    this.userId = map["userId"];
    this.name = map["name"];
    this.imgUrl = map["image"] == null ? "" : map["image"];
    this.clockIn = map["clock_in_time"] == null
        ? null
        : DateTime.parse(map['clock_in_time']);
    this.clockOut = map["clock_out_time"] == null
        ? null
        : DateTime.parse(map['clock_out_time']);
    this.late = map["late"] == null ? null : map["late"];
  }
}
