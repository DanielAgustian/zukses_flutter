import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/business-scope-service.dart';
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
    List<bool> bools = [];

    // directly throw into success load or fail load
    if (res == 200) {
      yield UploadAttachStateSuccess(kode: res);
    } else {
      yield UploadAttachStateFail();
    }
  }

  @override
  Stream<UploadAttachState> mapEventToState(UploadAttachEvent event) async* {
    if (event is UploadAttachNewEvent) {
      yield* mapUploadAttach(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
