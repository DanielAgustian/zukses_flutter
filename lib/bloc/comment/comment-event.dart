import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/comment-model.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllCommentEvent extends CommentEvent {
  final String idTask;
  LoadAllCommentEvent(this.idTask);
  List<Object> get props => [];
}

class AddCommentEvent extends CommentEvent {
  final CommentModel comment;

  AddCommentEvent(this.comment);
  List<Object> get props => [];
}

class UpdateCommentEvent extends CommentEvent {
  final CommentModel commentModel;
  final String comment;
  UpdateCommentEvent(this.commentModel, this.comment);
  List<Object> get props => [];
}

class DeleteCommentEvent extends CommentEvent {
  final CommentModel comment;

  DeleteCommentEvent(this.comment);
  List<Object> get props => [];
}

class CommentEventDidUpdated extends CommentEvent {
  final List<CommentModel> comment;
  const CommentEventDidUpdated(this.comment);

  @override
  List<Object> get props => [comment];
}
