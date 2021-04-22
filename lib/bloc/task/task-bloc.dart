import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/task/task-event.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(null);
  StreamSubscription _subscription;
  TaskServicesHTTP _taskServicesHTTP = TaskServicesHTTP();
  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is GetAllTaskEvent) {
      yield* mapGetTask(event);
    } else if (event is AddTaskEvent) {
      yield* mapAddTask(event);
    }
  }

  Stream<TaskState> mapGetTask(GetAllTaskEvent event) async* {
    yield TaskStateLoading();

    /*var res = await _taskServicesHTTP.fetchTask();
    if (res != null) {
      print(res);
      yield TaskStateSuccessLoad(res);
    } else {
      yield TaskStateFailLoad();
    }*/
  }

  Stream<TaskState> mapAddTask(AddTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.addTask(event.task);
    if (res == 200) {
      print(res);
      yield TaskStateAddSuccessLoad(project: res);
    } else {
      yield TaskStateAddFailLoad();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
