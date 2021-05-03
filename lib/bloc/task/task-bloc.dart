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
    } else if (event is AddTaskFreeEvent) {
      yield* mapAddTaskFree(event);
    }
  }

  Stream<TaskState> mapGetTask(GetAllTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.fetchTask(event.projectId);

    if (res != null) {
      print(res);
      yield TaskStateSuccessLoad(task: res);
      //print(state);
    } else {
      yield TaskStateFailLoad();
      //print(state);
    }
  }
  Stream<TaskState> mapLowPriorityTask(LoadLowPriorityTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.fetchTaskByPriority(event.priority);

    if (res != null) {
      print(res);
      yield TaskStateLowPrioritySuccessLoad(task: res);
      //print(state);
    } else {
      yield TaskStateLowPriorityFailLoad();
      //print(state);
    }
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

  Stream<TaskState> mapAddTaskFree(AddTaskFreeEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.addTaskFree(event.task);
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
