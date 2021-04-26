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
    print("mapGetProject" + res.toString());
    if (res != null && res is List<ProjectModel>) {
      print(res);
      yield ProjectStateSuccessLoad(project: res);
    } else {
      yield ProjectStateFailLoad();
    }
  }

  Stream<ProjectState> mapAddProject(AddProjectEvent event) async* {
    yield ProjectStateLoading();

    var res = await _projectServicesHTTP.addProject(event.project, event.image);
    if (res == 200) {
      print(res);
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
