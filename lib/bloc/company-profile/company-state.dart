import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/company-model.dart';


abstract class CompanyState extends Equatable {
  const CompanyState();

  List<Object> get props => [];
}

class CompanyStateLoading extends CompanyState {}

class CompanyStateFailLoad extends CompanyState {}

class CompanyStateSuccessLoad extends CompanyState {
  final CompanyModel company;

  CompanyStateSuccessLoad( {this.company});

  List<Object> get props => [company];

  @override
  String toString() {
    return 'Data : { Company List: $company }';
  }
}
class CompanyCodeStateSuccessLoad extends CompanyState {
  final CompanyModel company;

  CompanyCodeStateSuccessLoad( {this.company});

  List<Object> get props => [company];

  @override
  String toString() {
    return 'Data : { Company List: $company }';
  }
}
class CompanyCodeStateFailLoad extends CompanyState {}

class AddCompanyStateSuccessLoad extends CompanyState {
  final int code;

  AddCompanyStateSuccessLoad( {this.code});

  List<Object> get props => [code];

  @override
  String toString() {
    return 'Data : { Company List: $code }';
  }
}

class AddCompanyStateFailLoad extends CompanyState {}