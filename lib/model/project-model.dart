class ProjectModel {
  int id;
  String name, details, imgUrl;
  int totalTask;
  ProjectModel({this.id, this.name, this.details, this.imgUrl, this.totalTask});

  ProjectModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["project_name"];
    this.details = map["notes"];
    this.imgUrl = map["image"];
    this.totalTask = map["totalTask"];
  }
}
