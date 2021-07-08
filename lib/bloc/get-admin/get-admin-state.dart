import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/admin-model.dart';
import 'package:zukses_app_1/model/notif-nav-model.dart';

abstract class GetAdminState extends Equatable {
  const GetAdminState();

  List<Object> get props => [];
}

class GetAdminStateFailed extends GetAdminState {}

class GetAdminStateSuccess extends GetAdminState {
  final List<AdminModel> model;

  GetAdminStateSuccess(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}

class GetAdminStateLoading extends GetAdminState {}
