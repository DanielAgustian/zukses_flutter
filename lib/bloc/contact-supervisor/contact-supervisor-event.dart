import 'package:equatable/equatable.dart';

abstract class ContactSupervisorEvent extends Equatable {
  const ContactSupervisorEvent();

  List<Object> get props => [];
}

class ContactSupervisorAddEvent extends ContactSupervisorEvent {
  final String message, receiverId, typeId, about;
  ContactSupervisorAddEvent(
      {this.message, this.receiverId, this.typeId, this.about});
  List<Object> get props => [];
}

class ContactSupervisorGetEvent extends ContactSupervisorEvent {
  final String conversationId;
  ContactSupervisorGetEvent({this.conversationId});
  List<Object> get props => [];
}

class ContactSupervisorGetListEvent extends ContactSupervisorEvent {
  ContactSupervisorGetListEvent();
  List<Object> get props => [];
}

class ContactSupervisorAnswerEvent extends ContactSupervisorEvent {
  final String messageId, message, receiverId;
  ContactSupervisorAnswerEvent({this.message, this.messageId, this.receiverId});
  List<Object> get props => [];
}
