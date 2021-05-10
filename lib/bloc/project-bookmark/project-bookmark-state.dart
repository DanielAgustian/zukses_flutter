import 'package:equatable/equatable.dart';



abstract class ProjectBookmarkState extends Equatable {
  const ProjectBookmarkState();

  List<Object> get props => [];
}

class ProjectBookmarkStateLoading extends ProjectBookmarkState {}

class ProjectBookmarkStateFailLoad extends ProjectBookmarkState {}

class ProjectBookmarkStateSuccessLoad extends ProjectBookmarkState {
  final int kode;
  // handle for checklist user

  ProjectBookmarkStateSuccessLoad({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}
