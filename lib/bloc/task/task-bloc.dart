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
    } else if (event is UpdateTaskEvent) {
      yield* mapUpdateTask(event);
    } 
  }

  Stream<TaskState> mapGetTask(GetAllTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.fetchTask(event.projectId);

    if (res != null) {
      yield TaskStateSuccessLoad(task: res);
      
    } else {
      yield TaskStateFailLoad();
      
    }
  }

  

  Stream<TaskState> mapUpdateTask(UpdateTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.updateTask(event.task);
    if (res == 200) {
      yield TaskStateUpdateSuccess(kode: res);
    } else {
      yield TaskStateUpdateFail();
    }
  }

  Stream<TaskState> mapAddTask(AddTaskEvent event) async* {
    yield TaskStateLoading();

    var res = await _taskServicesHTTP.addTask(event.task);
    if (res == 200) {
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
