import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-event.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-state.dart';

class TaskPriorityBloc extends Bloc<TaskPriorityEvent, TaskPriorityState> {
  StreamSubscription _subscription;

  final TaskServicesHTTP _task = TaskServicesHTTP();

  TaskPriorityBloc() : super(null);

  // Bloc for loadd all TaskPriority
  Stream<TaskPriorityState> mapAllTaskPriority(
      LoadHighPriorityEvent event) async* {
    yield TaskPriorityStateLoading();
    // return list user model
    var res = await _task.fetchTaskByPriority(event.priority);
    // directly throw into success load or fail load
    if (res != null) {
      yield TaskPriorityStateSuccessLoad(task: res);
    } else {
      yield TaskPriorityStateFailLoad();
    }
  }

  Stream<TaskPriorityState> mapUpdatingTaskPriorityState(
      TaskPriorityEventDidUpdated event) async* {
    yield TaskPriorityStateSuccessLoad(task: event.leaveType);
  }

  @override
  Stream<TaskPriorityState> mapEventToState(TaskPriorityEvent event) async* {
    if (event is LoadHighPriorityEvent) {
      yield* mapAllTaskPriority(event);
    } else if (event is TaskPriorityEventDidUpdated) {
      yield* mapUpdatingTaskPriorityState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
