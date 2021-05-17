import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/project-services.dart';
import 'package:zukses_app_1/bloc/project/project-event.dart';
import 'package:zukses_app_1/bloc/project/project-state.dart';
import 'package:zukses_app_1/model/project-model.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(null);
  StreamSubscription _subscription;
  ProjectServicesHTTP _projectServicesHTTP = ProjectServicesHTTP();
  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is GetAllProjectEvent) {
      yield* mapGetProject(event);
    } else if (event is AddProjectEvent) {
      yield* mapAddProject(event);
    }
  }

  Stream<ProjectState> mapGetProject(GetAllProjectEvent event) async* {
    yield ProjectStateLoading();
    var res = await _projectServicesHTTP.fetchProject();

    List<bool> bools = [];

    if (res != null && res is List<ProjectModel>) {
      List<ProjectModel> temp = [];
      List<int> dataTrue = [], dataFalse = [];
      for (int i = 0; i < res.length; i++) {
        if (res[i].bookmark == 1) {
          dataTrue.add(i);
        } else if (res[i].bookmark == 0) {
          dataFalse.add(i);
        }
      }

      for (int i = 0; i < dataTrue.length; i++) {
        temp.add(res[dataTrue[i]]);
      }
      for (int i = 0; i < dataFalse.length; i++) {
        temp.add(res[dataFalse[i]]);
      }
      for (int i = 0; i < temp.length; i++) {
        int data = temp[i].bookmark;
        if (data == 0) {
          bools.add(false);
        } else if (data == 1) {
          bools.add(true);
        }
      }

      yield ProjectStateSuccessLoad(project: temp, bools: bools);
    } else {
      yield ProjectStateFailLoad();
    }
  }

  Stream<ProjectState> mapAddProject(AddProjectEvent event) async* {
    yield ProjectStateLoading();

    var res = await _projectServicesHTTP.addProject(event.project, event.image);
    if (res == 200) {
      yield ProjectStateAddSuccessLoad(code: res);
    } else {
      yield ProjectStateAddFailLoad();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
