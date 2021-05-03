import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/checklist-task-services.dart';

import 'package:zukses_app_1/bloc/checklist-task-put/checklist-task-put-event.dart';
import 'package:zukses_app_1/bloc/checklist-task-put/checklist-task-put-state.dart';

class CLTPBloc extends Bloc<CLTPEvent, CLTPState> {
  StreamSubscription _subscription;

  CheckListTaskService _checkListTask = CheckListTaskService();

  CLTPBloc() : super(null);

  // Bloc for loadd all CLTP

  Stream<CLTPState> mapPutCLTP(PutCLTPEvent event) async* {
    yield CLTPStateLoading();
    var res = await _checkListTask.putCheckList(event.checkListId);
    if (res != null) {
      yield CLTPStateAddSuccessLoad(res);
    } else {
      yield CLTPStateAddFailLoad();
    }
  }

  /*Stream<CLTPState> mapUpdatingCLTPState(CLTPEventDidUpdated event) async* {
    yield CLTPStateGetSuccessLoad(event.model);
  }*/

  @override
  Stream<CLTPState> mapEventToState(CLTPEvent event) async* {
    if (event is PutCLTPEvent) {
      yield* mapPutCLTP(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
