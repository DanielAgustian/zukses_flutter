import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/attachment-model.dart';

abstract class UploadAttachState extends Equatable {
  const UploadAttachState();

  List<Object> get props => [];
}

class UploadAttachStateLoading extends UploadAttachState {}

class UploadAttachStateFail extends UploadAttachState {}

class UploadAttachStateSuccess extends UploadAttachState {
  final int kode;
  final List<AttachmentModel> attach;
  // handle for checklist user

  UploadAttachStateSuccess({this.kode, this.attach});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}

class UploadAttachStateFailLoad extends UploadAttachState {}
class UploadAttachStateSuccessLoad extends UploadAttachState {
  
  final List<AttachmentModel> attach;
  // handle for checklist user

  UploadAttachStateSuccessLoad({this.attach});

  List<Object> get props => [attach];

  @override
  String toString() {
    return 'Data : { employee List: $attach }';
  }
}