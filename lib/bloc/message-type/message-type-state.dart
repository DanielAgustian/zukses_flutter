import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/message-type-model.dart';

abstract class MessageTypeState extends Equatable {
  const MessageTypeState();

  List<Object> get props => [];
}

class MessageTypeStateFailed extends MessageTypeState {}

class MessageTypeStateSuccess extends MessageTypeState {
  final List<MessageTypeModel> models;

  MessageTypeStateSuccess(this.models);
}

class MessageTypeStateLoading extends MessageTypeState {}
