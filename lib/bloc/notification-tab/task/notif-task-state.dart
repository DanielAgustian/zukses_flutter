import 'package:equatable/equatable.dart';

abstract class NotificationTaskState extends Equatable {
  const NotificationTaskState();

  List<Object> get props => [];
}

class NotificationTaskStateFailed extends NotificationTaskState {}

class NotificationTaskStateSuccess extends NotificationTaskState {}

class NotificationTaskStateLoading extends NotificationTaskState {}
