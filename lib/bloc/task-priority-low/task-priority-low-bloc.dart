import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/task-priority-low/task-priority-low-event.dart';
import 'package:zukses_app_1/bloc/task-priority-low/task-priority-low-state.dart';



class TaskPriorityLowBloc extends Bloc<TaskPriorityLowEvent, TaskPriorityLowState> {
  StreamSubscription _subscription;

  final TaskServicesHTTP _task = TaskServicesHTTP();

  TaskPriorityLowBloc() : super(null);

  // Bloc for loadd all TaskPriorityLow
  Stream<TaskPriorityLowState> mapAllTaskPriorityLow(
      LoadLowPriorityEvent event) async* {
    yield TaskPriorityLowStateLoading();
    // return list user model
    var res = await _task.fetchTaskByPriority(event.priority);
    // directly throw into success load or fail load
    if (res != null) {
      yield TaskPriorityLowStateSuccessLoad(task: res);
    } else {
      yield TaskPriorityLowStateFailLoad();
    }
  }

  Stream<TaskPriorityLowState> mapUpdatingTaskPriorityLowState(
      TaskPriorityLowEventDidUpdated event) async* {
    yield TaskPriorityLowStateSuccessLoad(task: event.leaveType);
  }

  @override
  Stream<TaskPriorityLowState> mapEventToState(TaskPriorityLowEvent event) async* {
    if (event is LoadLowPriorityEvent) {
      yield* mapAllTaskPriorityLow(event);
    } else if (event is TaskPriorityLowEventDidUpdated) {
      yield* mapUpdatingTaskPriorityLowState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
