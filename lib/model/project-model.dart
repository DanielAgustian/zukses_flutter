class ProjectModel {
  int id;
  String name, details, imgUrl;
  int totalTask;
  int bookmark;
  ProjectModel(
      {this.id,
      this.name,
      this.details,
      this.imgUrl,
      this.totalTask,
      this.bookmark});

  ProjectModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["project_name"];
    this.details = map["notes"];
    this.imgUrl = map["image"];
    this.totalTask = map["totalTask"];
    this.bookmark = map["bookmark"];
  }
}
