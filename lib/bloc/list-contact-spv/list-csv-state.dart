import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/admin-model.dart';
import 'package:zukses_app_1/model/contact-supervisor-modal.dart';
import 'package:zukses_app_1/model/list-contact-spv-model.dart';
import 'package:zukses_app_1/model/notif-nav-model.dart';

abstract class ListCSVState extends Equatable {
  const ListCSVState();

  List<Object> get props => [];
}

class ListCSVGetListStateFailed extends ListCSVState {}

class ListCSVGetListStateSuccess extends ListCSVState {
  final List<ContactSupervisorListModel> model;

  ListCSVGetListStateSuccess(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}

class ListCSVDeleteStateSuccess extends ListCSVState {
  ListCSVDeleteStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { employee List:  }';
  }
}
class ListCSVDeleteStateFailed extends ListCSVState {}
class ListCSVStateLoading extends ListCSVState {}
