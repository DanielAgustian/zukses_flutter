import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/contact-supervisor-service.dart';
import 'package:zukses_app_1/model/contact-supervisor-modal.dart';
import 'contact-supervisor-event.dart';
import 'contact-supervisor-state.dart';

class ContactSupervisorBloc
    extends Bloc<ContactSupervisorEvent, ContactSupervisorState> {
  ContactSupervisorBloc() : super(null);
  StreamSubscription _subscription;
  ContactSupervisorServiceHTTP _cspv =
      ContactSupervisorServiceHTTP(); //CompanyServiceHTTP _companyServicesHTTP = CompanyServiceHTTP();
  @override
  Stream<ContactSupervisorState> mapEventToState(
      ContactSupervisorEvent event) async* {
    if (event is ContactSupervisorAddEvent) {
      yield* mapAddContactSupervisor(event);
    } else if (event is ContactSupervisorGetEvent) {
      yield* mapGetContactSupervisor(event);
    } else if (event is ContactSupervisorAnswerEvent) {
      yield* mapAnswerContactSupervisor(event);
    } else if (event is ContactSupervisorGetListEvent) {
      yield* mapGetContactSupervisorList(event);
    }
  }

  Stream<ContactSupervisorState> mapAddContactSupervisor(
      ContactSupervisorAddEvent event) async* {
    yield ContactSupervisorStateLoading();
    var res = await _cspv.createContactSupervisor(
        event.message, event.typeId, event.about, event.receiverId);

    if (res >= 200 && res < 300) {
      yield ContactSupervisorAddStateSuccess();
    } else {
      yield ContactSupervisorStateFailed();
    }
  }

  Stream<ContactSupervisorState> mapAnswerContactSupervisor(
      ContactSupervisorAnswerEvent event) async* {
    yield ContactSupervisorStateLoading();
    var res = await _cspv.answerContactSupervisor(
        event.messageId, event.message, event.receiverId);

    if (res >= 200 && res < 300) {
      yield ContactSupervisorAnswerStateSuccess();
    } else {
      yield ContactSupervisorStateFailed();
    }
  }

  Stream<ContactSupervisorState> mapGetContactSupervisor(
      ContactSupervisorGetEvent event) async* {
    yield ContactSupervisorStateLoading();
    var res = await _cspv.getContactSupervisor(event.conversationId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myId = prefs.getString('myID');
    print(myId);
    if (res != null) {
      var lastConversation = res[res.length - 1];
      var myLastConversation = ContactSupervisorModel();
      res.forEach((element) {
        if (element.senderId.toString() == myId) {
          myLastConversation = element;
        }
      });
      yield ContactSupervisorGetStateSuccess(
          res, lastConversation, myLastConversation);
    } else {
      yield ContactSupervisorStateFailed();
    }
  }

  Stream<ContactSupervisorState> mapGetContactSupervisorList(
      ContactSupervisorGetListEvent event) async* {
    yield ContactSupervisorStateLoading();
    var res = await _cspv.getContactSupervisorList();

    if (res != null) {
      yield ContactSupervisorGetListStateSuccess(res);
    } else {
      yield ContactSupervisorGetListStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
