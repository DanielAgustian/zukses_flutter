import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/notif-model.dart';

abstract class NotifAllState extends Equatable {
  const NotifAllState();

  List<Object> get props => [];
}

class NotifAllStateFailed extends NotifAllState {}

class NotifAllStateSuccess extends NotifAllState {
  

  NotifAllStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { employee List: }';
  }
}
class NotifAllStateSuccessLoad extends NotifAllState {
  final List<NotifModel> models;

  NotifAllStateSuccessLoad(this.models);
  List<Object> get props => [models];

  @override
  String toString() {
    return 'Data : { employee List: $models }';
  }
}
class NotifAllStateLoading extends NotifAllState {}
