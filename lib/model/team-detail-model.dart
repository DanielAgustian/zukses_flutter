class TeamDetailModel {
  int id, companyid;
  String teamName, invitationLink;
  TeamDetailModel({
    this.id,
    this.companyid,
    this.teamName,
    this.invitationLink,
  });
  TeamDetailModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.companyid = map['company_id'];
    this.teamName = map['team_name'];
    this.invitationLink = map['invitation_link'];
  }
}
