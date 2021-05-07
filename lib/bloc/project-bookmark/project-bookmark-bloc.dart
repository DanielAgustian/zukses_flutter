import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/project-services.dart';

import 'package:zukses_app_1/bloc/project-bookmark/project-bookmark-event.dart';
import 'package:zukses_app_1/bloc/project-bookmark/project-bookmark-state.dart';

class ProjectBookmarkBloc
    extends Bloc<ProjectBookmarkEvent, ProjectBookmarkState> {
  StreamSubscription _subscription;

  final ProjectServicesHTTP _project = ProjectServicesHTTP();

  ProjectBookmarkBloc() : super(null);

  // Bloc for loadd all ProjectBookmark
  Stream<ProjectBookmarkState> mapDoProjectBookmark(DoProjectBookmarkEvent event) async* {
    yield ProjectBookmarkStateLoading();
    // return list user model
    var res = await _project.bookmarkProject(event.projectId);

    // return checkbox handler

    // directly throw into success load or fail load
    if (res== 200) {
      yield ProjectBookmarkStateSuccessLoad(kode: res);
    } else {
      yield ProjectBookmarkStateFailLoad();
    }
  }
  
  @override
  Stream<ProjectBookmarkState> mapEventToState(
      ProjectBookmarkEvent event) async* {
    if (event is DoProjectBookmarkEvent) {
      yield* mapDoProjectBookmark(event);
    } 
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
