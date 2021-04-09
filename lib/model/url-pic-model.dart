class UrlPicModel {
  String height, url, width;
  bool isSilhoutte;
  UrlPicModel({this.height, this.isSilhoutte, this.url, this.width});
  UrlPicModel.fromJson(Map<String, dynamic> map) {
    this.height = map['height'].toString();
    this.isSilhoutte = map['is_silhouette'];
    this.url = map['url'];
    this.width = map['width'].toString();
  }
}
