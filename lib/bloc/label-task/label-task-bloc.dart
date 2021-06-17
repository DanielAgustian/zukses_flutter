import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/label-task.services.dart';

import 'package:zukses_app_1/bloc/label-task/label-task-state.dart';

import 'label-task-event.dart';

class LabelTaskBloc extends Bloc<LabelTaskEvent, LabelTaskState> {
  StreamSubscription _subscription;

  LabelTaskServiceHTTP labelTaskService = LabelTaskServiceHTTP();

  LabelTaskBloc() : super(null);

  // Bloc for loadd all LabelTask
  Stream<LabelTaskState> mapAllLabelTask() async* {
    yield LabelTaskStateLoading();
    // return list user model
    var res = await labelTaskService.fetchlabelTask();
    // return checkbox handler

    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      yield LabelTaskStateSuccessLoad(labelTask: res);
    } else {
      yield LabelTaskStateFailLoad();
    }
  }

  Stream<LabelTaskState> mapAddLabelTask(AddLabelTaskEvent event) async* {
    yield LabelTaskStateLoading();
    // return list user model
    var res = await labelTaskService.createlabelTask(event.name);
    // return checkbox handler

    // directly throw into success load or fail load
    if (res == 200) {
      yield LabelTaskAddStateSuccessLoad(kode: res);
    } else {
      yield LabelTaskAddStateFailLoad();
    }
  }

  Stream<LabelTaskState> mapUpdatingLabelTaskState(
      LabelTaskEventDidUpdated event) async* {
    yield LabelTaskStateSuccessLoad(labelTask: event.labelTask);
  }

  @override
  Stream<LabelTaskState> mapEventToState(LabelTaskEvent event) async* {
    if (event is LoadAllLabelTaskEvent) {
      yield* mapAllLabelTask();
    } else if (event is LabelTaskEventDidUpdated) {
      yield* mapUpdatingLabelTaskState(event);
    } else if (event is AddLabelTaskEvent) {
      yield* mapAddLabelTask(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
