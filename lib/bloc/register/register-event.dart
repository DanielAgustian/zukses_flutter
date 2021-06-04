import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/register-model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllRegisterEvent extends RegisterEvent {
  LoadAllRegisterEvent();
  List<Object> get props => [];
}

class AddRegisterIndividuEvent extends RegisterEvent {
  final RegisterModel register;
  final String tokenFCM;
  AddRegisterIndividuEvent(this.register, {this.tokenFCM});
  List<Object> get props => [register];
}

class AddRegisterTeamMemberEvent extends RegisterEvent {
  final RegisterModel register;
  final String link;
  final String tokenFCM;
  AddRegisterTeamMemberEvent(this.register, this.link, {this.tokenFCM});
  List<Object> get props => [register, link];
}

class AddRegisterFacebook extends RegisterEvent {
  final String tokenFCM;
  AddRegisterFacebook({this.tokenFCM});
}

class AddRegisterGoogle extends RegisterEvent {
  final String tokenFCM;
  AddRegisterGoogle({this.tokenFCM});
}

class AddRegisterTeamEvent extends RegisterEvent {
  final String link;
  final List<String> email;
  final String namaTeam;
  final String token;
  AddRegisterTeamEvent({this.namaTeam, this.token, this.link, this.email});
  List<Object> get props => [namaTeam, token];
}

class AddRegisterCompanyEvent extends RegisterEvent {
  final String kode;
  final String token;
  AddRegisterCompanyEvent({this.kode, this.token});
  List<Object> get props => [kode, token];
}

class PostAcceptanceCompanyEvent extends RegisterEvent {
  PostAcceptanceCompanyEvent();
  List<Object> get props => [];
}

class RegisterEventDidUpdated extends RegisterEvent {
  final List<RegisterModel> register;
  const RegisterEventDidUpdated(this.register);

  @override
  List<Object> get props => [register];
}
