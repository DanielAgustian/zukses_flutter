import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/notif-nav-model.dart';

abstract class NotifNavState extends Equatable {
  const NotifNavState();

  List<Object> get props => [];
}

class NotifNavStateFailed extends NotifNavState {}

class NotifNavStateSuccess extends NotifNavState {
  final NotifNavModel model;

  NotifNavStateSuccess(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}

class NotifNavStateLoading extends NotifNavState {}
