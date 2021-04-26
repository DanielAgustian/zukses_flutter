import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';


abstract class BussinessScopeEvent extends Equatable {
  const BussinessScopeEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllBussinessScopeEvent extends BussinessScopeEvent {
  LoadAllBussinessScopeEvent();
  List<Object> get props => [];
}

class BussinessScopeEventDidUpdated extends BussinessScopeEvent {
  final List<BussinessScopeModel> bussinessScope;
  const BussinessScopeEventDidUpdated(this.bussinessScope);

  @override
  List<Object> get props => [bussinessScope];
}