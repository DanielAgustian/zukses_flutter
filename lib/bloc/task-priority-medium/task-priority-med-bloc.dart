import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/task-services.dart';
import 'package:zukses_app_1/bloc/task-priority-medium/task-priority-med-event.dart';



import 'task-priority-med-state.dart';


class TaskPriorityMedBloc extends Bloc<TaskPriorityMedEvent, TaskPriorityMedState> {
  StreamSubscription _subscription;

  final TaskServicesHTTP _task = TaskServicesHTTP();

  TaskPriorityMedBloc() : super(null);

  // Bloc for loadd all TaskPriorityMed
  Stream<TaskPriorityMedState> mapAllTaskPriorityMed(
      LoadMedPriorityEvent event) async* {
    yield TaskPriorityMedStateLoading();
    // return list user model
    var res = await _task.fetchTaskByPriority(event.priority);
    // directly throw into success load or fail load
    if (res != null) {
      yield TaskPriorityMedStateSuccessLoad(task: res);
    } else {
      yield TaskPriorityMedStateFailLoad();
    }
  }

  Stream<TaskPriorityMedState> mapUpdatingTaskPriorityMedState(
      TaskPriorityMedEventDidUpdated event) async* {
    yield TaskPriorityMedStateSuccessLoad(task: event.leaveType);
  }

  @override
  Stream<TaskPriorityMedState> mapEventToState(TaskPriorityMedEvent event) async* {
    if (event is LoadMedPriorityEvent) {
      yield* mapAllTaskPriorityMed(event);
    } else if (event is TaskPriorityMedEventDidUpdated) {
      yield* mapUpdatingTaskPriorityMedState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
