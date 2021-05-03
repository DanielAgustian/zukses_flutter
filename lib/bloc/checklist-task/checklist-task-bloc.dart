import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/checklist-task-services.dart';

import 'package:zukses_app_1/bloc/checklist-task/checklist-task-event.dart';
import 'package:zukses_app_1/bloc/checklist-task/checklist-task-state.dart';

class CLTBloc extends Bloc<CLTEvent, CLTState> {
  StreamSubscription _subscription;

  CheckListTaskService _checkListTask = CheckListTaskService();

  CLTBloc() : super(null);

  // Bloc for loadd all CLT
  Stream<CLTState> mapAllCLT(LoadAllCLTEvent event) async* {
    yield CLTStateLoading();
    // return list user model

    var res = await _checkListTask.getCheckList(event.taskId);

    // return checkbox handler
    List<bool> bools = [];

    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      for (int i = 0; i < res.length; i++) {
        if (res[i].status == 0) {
          bools.add(false);
        } else {
          bools.add(true);
        }
      }

      yield CLTStateGetSuccessLoad(bools, res);
    } else {
      yield CLTStateGetFailLoad();
    }
  }

  Stream<CLTState> mapAddCLT(AddCLTEvent event) async* {
    yield CLTStateLoading();
    var res =
        await _checkListTask.addCheckList(event.taskId, event.checkListName);
    if (res != null) {
      yield CLTStateAddSuccessLoad(res);
    } else {
      yield CLTStateAddFailLoad();
    }
  }

  Stream<CLTState> mapPutCLT(PutCLTEvent event) async* {
    yield CLTStateLoading();
    var res = await _checkListTask.putCheckList(event.checkListId);
    if (res != null) {
      yield CLTStateAddSuccessLoad(res);
    } else {
      yield CLTStateAddFailLoad();
    }
  }

  /*Stream<CLTState> mapUpdatingCLTState(CLTEventDidUpdated event) async* {
    yield CLTStateGetSuccessLoad(event.model);
  }*/

  @override
  Stream<CLTState> mapEventToState(CLTEvent event) async* {
    if (event is LoadAllCLTEvent) {
      yield* mapAllCLT(event);
    } /*else if (event is CLTEventDidUpdated) {
      yield* mapUpdatingCLTState(event);
    } */
    else if (event is AddCLTEvent) {
      yield* mapAddCLT(event);
    } else if (event is PutCLTEvent) {
      yield* mapPutCLT(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
