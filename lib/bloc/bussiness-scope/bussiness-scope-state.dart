import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';


abstract class BussinessScopeState extends Equatable {
  const BussinessScopeState();

  List<Object> get props => [];
}

class BussinessScopeStateLoading extends BussinessScopeState {}

class BussinessScopeStateFailLoad extends BussinessScopeState {}

class BussinessScopeStateSuccessLoad extends BussinessScopeState {
  final List<BussinessScopeModel> bussinessScope;
  // handle for checklist user
  

  BussinessScopeStateSuccessLoad({this.bussinessScope});

  List<Object> get props => [bussinessScope];

  @override
  String toString() {
    return 'Data : { employee List: $bussinessScope }';
  }
}
