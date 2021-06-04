class UrlPicModel {
  String height, url, width;
  bool isSilhoutte;
  UrlPicModel({this.height, this.isSilhoutte, this.url, this.width});
  UrlPicModel.fromJson(Map<String, dynamic> map) {
    this.height = map['height'] == null ? "" : map['height'].toString();
    this.isSilhoutte =
        map['is_silhouette'] == null ? false : map['is_silhouette'];
    this.url = map['url'];
    this.width = map['width'] == null ? "" : map['width'].toString();
  }
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'is_silhoutte': isSilhoutte,
      'url': url,
      'width': width
    };
  }
}
