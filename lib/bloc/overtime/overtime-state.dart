import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/overtime-model.dart';

abstract class OvertimeState extends Equatable {
  const OvertimeState();

  List<Object> get props => [];
}

//State for POST
class OvertimeStateSuccess extends OvertimeState {}

class OvertimeStateFail extends OvertimeState {}

//Universal State for Waiting Response
class OvertimeStateLoading extends OvertimeState {}

//State for Get
class OvertimeStateFailLoad extends OvertimeState {}

class OvertimeStateSuccessLoad extends OvertimeState {
  final List<OvertimeModel> overtime;
  // handle for checklist user

  OvertimeStateSuccessLoad({this.overtime});

  List<Object> get props => [overtime];

  @override
  String toString() {
    return 'Data : { employee List: $overtime }';
  }
}
