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

  AddRegisterIndividuEvent(this.register);
  List<Object> get props => [register];
}

class AddRegisterTeamMemberEvent extends RegisterEvent {
  final RegisterModel register;
  final String link;
  AddRegisterTeamMemberEvent(this.register, this.link);
  List<Object> get props => [register, link];
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

class RegisterEventDidUpdated extends RegisterEvent {
  final List<RegisterModel> register;
  const RegisterEventDidUpdated(this.register);

  @override
  List<Object> get props => [register];
}
