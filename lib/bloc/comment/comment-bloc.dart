import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/comment-services.dart';
import 'package:zukses_app_1/API/leave-type-services.dart';
import 'package:zukses_app_1/bloc/comment/comment-event.dart';
import 'package:zukses_app_1/bloc/comment/comment-state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  StreamSubscription _subscription;

  final CommentServicesHTTP _commentServiceHTTP = CommentServicesHTTP();

  CommentBloc() : super(null);

  // Bloc for loadd all Comment
  Stream<CommentState> mapAllComment(LoadAllCommentEvent event) async* {
    yield CommentStateLoading();
    // return list user model
    var res = await _commentServiceHTTP.fetchComment(event.idTask);
    if (res.length > 0 && res != null) {
      yield CommentStateGetSuccessLoad(comment: res);
    } else {
      yield CommentStateGetFailLoad();
    }
  }

  Stream<CommentState> mapAddComment(AddCommentEvent event) async* {
    yield CommentStateLoading();
    // return list user model
    var res = await _commentServiceHTTP.addComment(event.comment);
    if (res != null) {
      if (res == 200) {
        yield CommentStateAddSuccessLoad(kode: res);
      } else {
        yield CommentStateAddFailLoad();
      }
    } else {
      yield CommentStateAddFailLoad();
    }
  }

  Stream<CommentState> mapUpdateComment(UpdateCommentEvent event) async* {
    yield CommentStateLoading();
    // return list user model
    var res =
        await _commentServiceHTTP.updateComment(event.comment, event.image);
    if (res != null) {
      if (res == 200) {
        yield CommentStateUpdateSuccessLoad(kode: res);
      } else {
        yield CommentStateUpdateFailLoad();
      }
    } else {
      yield CommentStateUpdateFailLoad();
    }
  }

  Stream<CommentState> mapDeleteComment(DeleteCommentEvent event) async* {
    yield CommentStateLoading();
    // return list user model
    var res = await _commentServiceHTTP.deleteComment(event.comment);
    if (res != null) {
      if (res == 200) {
        yield CommentStateDeleteSuccessLoad(kode: res);
      } else {
        yield CommentStateDeleteFailLoad();
      }
    } else {
      yield CommentStateDeleteFailLoad();
    }
  }

  Stream<CommentState> mapUpdatingCommentState(
      CommentEventDidUpdated event) async* {
    yield CommentStateGetSuccessLoad(comment: event.comment);
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is LoadAllCommentEvent) {
      yield* mapAllComment(event);
    } else if (event is CommentEventDidUpdated) {
      yield* mapUpdatingCommentState(event);
    } else if (event is AddCommentEvent) {
      yield* mapAddComment(event);
    } else if (event is UpdateCommentEvent) {
      yield* mapUpdateComment(event);
    } else if (event is DeleteCommentEvent) {
      yield* mapDeleteComment(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
