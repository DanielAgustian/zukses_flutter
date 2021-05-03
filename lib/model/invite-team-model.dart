class InviteTeamModel {
  String idTeam, link;
  InviteTeamModel({this.idTeam, this.link});
  InviteTeamModel.fromJson(Map<String, dynamic> map) {
    idTeam = map["idTeam"];
    link = map["link"];
  }
}
