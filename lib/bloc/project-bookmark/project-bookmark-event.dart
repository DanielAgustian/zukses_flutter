import 'package:equatable/equatable.dart';

abstract class ProjectBookmarkEvent extends Equatable {
  const ProjectBookmarkEvent();

  List<Object> get props => [];
}

// Load all employee data
class DoProjectBookmarkEvent extends ProjectBookmarkEvent {
  final String projectId;
  DoProjectBookmarkEvent(this.projectId);
  List<Object> get props => [];
}

