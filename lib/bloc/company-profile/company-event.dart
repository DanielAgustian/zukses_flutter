import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/company-model.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  List<Object> get props => [];
}

class CompanyEventGetProfile extends CompanyEvent {
  const CompanyEventGetProfile();

  @override
  List<Object> get props => [];
}

class CompanyEventGetCode extends CompanyEvent {
  final String kode;
  const CompanyEventGetCode({this.kode});

  @override
  List<Object> get props => [];
}

class CompanyEventDidUpdated extends CompanyEvent {
  final CompanyModel company;
  const CompanyEventDidUpdated(this.company);

  @override
  List<Object> get props => [company];
}

class AddCompanyEvent extends CompanyEvent {
  final CompanyModel companyModel;
  final String token, scope;
  AddCompanyEvent({this.companyModel, this.token, this.scope});
  @override
  List<Object> get props => [companyModel];
}
