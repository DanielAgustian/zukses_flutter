import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
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

class AddRegisterTeamEvent extends RegisterEvent {
  final RegisterModel register;
  final String namaTeam;
  AddRegisterTeamEvent(this.register, this.namaTeam);
  List<Object> get props => [register];
}

class AddRegisterCompanyEvent extends RegisterEvent{
  final RegisterModel register;
  final String kode;
  AddRegisterCompanyEvent(this.register, this.kode);
  List<Object> get props => [register];
}

class RegisterEventDidUpdated extends RegisterEvent {
  final List<RegisterModel> register;
  const RegisterEventDidUpdated(this.register);

  @override
  List<Object> get props => [register];
}
