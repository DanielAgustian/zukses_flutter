import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/project-model.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  List<Object> get props => [];
}

class ProjectStateLoading extends ProjectState {}

class ProjectStateAddSuccessLoad extends ProjectState {
  final int code;

  ProjectStateAddSuccessLoad({this.code});

  List<Object> get props => [code];

  @override
  String toString() {
    return 'Data : { employee List: $code }';
  }
}

class ProjectStateAddFailLoad extends ProjectState {}

class ProjectStateFailLoad extends ProjectState {}

class ProjectStateSuccessLoad extends ProjectState {
  final List<ProjectModel> project;

  ProjectStateSuccessLoad({this.project});

  List<Object> get props => [project];

  @override
  String toString() {
    return 'Data : { employee List: $project }';
  }
}
