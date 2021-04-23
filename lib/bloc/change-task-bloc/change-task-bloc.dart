import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/business-scope-service.dart';
import 'package:zukses_app_1/API/leave-type-services.dart';
import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-event.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-state.dart';
import 'package:zukses_app_1/bloc/change-task-bloc/change-task-event.dart';
import 'package:zukses_app_1/bloc/change-task-bloc/change-task.state.dart';

class ChangeTaskBloc extends Bloc<ChangeTaskEvent, ChangeTaskState> {
  StreamSubscription _subscription;

  final TaskServicesHTTP _taskServices = TaskServicesHTTP();

  ChangeTaskBloc() : super(null);

  // Bloc for loadd all ChangeTask
  Stream<ChangeTaskState> mapChangeTask(ChangeTaskUpdateEvent event) async* {
    yield ChangeTaskStateLoading();
    // return list user model
    var res =
        await _taskServices.changeProgressTask(event.idTask, event.progress);

    // return checkbox handler
    List<bool> bools = [];

    // directly throw into success load or fail load
    if (res == 200) {
      yield ChangeTaskStateSuccessLoad(code: res);
    } else {
      yield ChangeTaskStateFailLoad();
    }
  }

  @override
  Stream<ChangeTaskState> mapEventToState(ChangeTaskEvent event) async* {
    if (event is ChangeTaskUpdateEvent) {
      yield* mapChangeTask(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
