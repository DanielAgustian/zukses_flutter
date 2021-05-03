import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/upload-attachment/upload-attachment-event.dart';
import 'package:zukses_app_1/bloc/upload-attachment/upload-attachment-state.dart';

class UploadAttachBloc extends Bloc<UploadAttachEvent, UploadAttachState> {
  StreamSubscription _subscription;

  final TaskServicesHTTP _task = TaskServicesHTTP();

  UploadAttachBloc() : super(null);

  // Bloc for loadd all UploadAttach
  Stream<UploadAttachState> mapUploadAttach(UploadAttachNewEvent event) async* {
    yield UploadAttachStateLoading();
    // return list user model
    var res = await _task.uploadAttachment(event.idTask, event.image);

    // return checkbox handler

    // directly throw into success load or fail load
    if (res != null) {
      yield UploadAttachStateSuccess(kode: res);
    } else {
      yield UploadAttachStateFail();
    }
  }

  Stream<UploadAttachState> mapGetAttachment(
      UploadAttachGetEvent event) async* {
    yield UploadAttachStateLoading();
    // return list user model
    var res = await _task.getAttachment(event.idTask);

    // return checkbox handler

    // directly throw into success load or fail load
    if (res != null) {
      yield UploadAttachStateSuccessLoad(attach: res);
    } else {
      yield UploadAttachStateFailLoad();
    }
  }

  @override
  Stream<UploadAttachState> mapEventToState(UploadAttachEvent event) async* {
    if (event is UploadAttachNewEvent) {
      yield* mapUploadAttach(event);
    } else if (event is UploadAttachGetEvent) {
      yield* mapGetAttachment(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
