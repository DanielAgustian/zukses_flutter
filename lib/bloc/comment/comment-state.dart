import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/comment-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';


abstract class CommentState extends Equatable {
  const CommentState();

  List<Object> get props => [];
}

class CommentStateLoading extends CommentState {}

//=================State for Add Comment======================//
class CommentStateAddFailLoad extends CommentState {}

class CommentStateAddSuccessLoad extends CommentState {
  final int kode;
  // handle for checklist user
  

  CommentStateAddSuccessLoad({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}
//===================================================///
//

//=====================State for Delete Comment==============//
class CommentStateDeleteFailLoad extends CommentState {}

class CommentStateDeleteSuccessLoad extends CommentState {
  final int kode;
  // handle for checklist user
  

  CommentStateDeleteSuccessLoad({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}
//=========================================================
//
//
//
//===============State for Update Comment===================
class CommentStateUpdateFailLoad extends CommentState {}

class CommentStateUpdateSuccessLoad extends CommentState {
  final int kode;
  // handle for checklist user
  

  CommentStateUpdateSuccessLoad({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}
//===============================================================


//=====================State for Get Comment======================
class CommentStateGetFailLoad extends CommentState {}

class CommentStateGetSuccessLoad extends CommentState {
  final List<CommentModel> comment;
  // handle for checklist user
  

  CommentStateGetSuccessLoad({this.comment});

  List<Object> get props => [comment];

  @override
  String toString() {
    return 'Data : { employee List: $comment }';
  }
}
//===========================================================