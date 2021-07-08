import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/admin-model.dart';
import 'package:zukses_app_1/model/contact-supervisor-modal.dart';
import 'package:zukses_app_1/model/list-contact-spv-model.dart';
import 'package:zukses_app_1/model/notif-nav-model.dart';

abstract class ContactSupervisorState extends Equatable {
  const ContactSupervisorState();

  List<Object> get props => [];
}

class ContactSupervisorStateFailed extends ContactSupervisorState {}



class ContactSupervisorAddStateSuccess extends ContactSupervisorState {
  ContactSupervisorAddStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { }';
  }
}
class ContactSupervisorDeleteStateSuccess extends ContactSupervisorState {
  ContactSupervisorDeleteStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { }';
  }
}
class ContactSupervisorGetStateSuccess extends ContactSupervisorState {
  final List<ContactSupervisorModel> model;
  final ContactSupervisorModel lastConversation;
  final ContactSupervisorModel myLastConversation;
  ContactSupervisorGetStateSuccess(
      this.model, this.lastConversation, this.myLastConversation);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}



class ContactSupervisorAnswerStateSuccess extends ContactSupervisorState {
  ContactSupervisorAnswerStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { employee List:  }';
  }
}

class ContactSupervisorStateLoading extends ContactSupervisorState {}
