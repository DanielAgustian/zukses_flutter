import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/project-model.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  List<Object> get props => [];
}

class GetAllProjectEvent extends ProjectEvent {
  final List<ProjectModel> project;

  GetAllProjectEvent({this.project});
  List<Object> get props => [project];
}

class AddProjectEvent extends ProjectEvent {
  final ProjectModel project;
  final File image;
  AddProjectEvent(this.project, this.image);
  List<Object> get props => [project, image];
}
