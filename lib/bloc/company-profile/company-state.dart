import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/company-model.dart';
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
  final List<CompanyModel> company;

  CompanyCodeStateSuccessLoad( {this.company});

  List<Object> get props => [company];

  @override
  String toString() {
    return 'Data : { Company List: $company }';
  }
}
class CompanyCodeStateFailLoad extends CompanyState {}

