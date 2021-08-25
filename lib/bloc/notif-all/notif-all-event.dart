import 'package:equatable/equatable.dart';

abstract class NotifAllEvent extends Equatable {
  const NotifAllEvent();

  List<Object> get props => [];
}

class GetNotifForAllEvent extends NotifAllEvent {
  GetNotifForAllEvent();
  List<Object> get props => [];
}

class MarkNotifForAllEvent extends NotifAllEvent {
  MarkNotifForAllEvent();
  List<Object> get props => [];
}

class MarkNotifForOneEvent extends NotifAllEvent {
  final int notifId;
  MarkNotifForOneEvent({this.notifId});
  List<Object> get props => [];
}
