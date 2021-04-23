import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

abstract class UploadAttachState extends Equatable {
  const UploadAttachState();

  List<Object> get props => [];
}

class UploadAttachStateLoading extends UploadAttachState {}

class UploadAttachStateFail extends UploadAttachState {}

class UploadAttachStateSuccess extends UploadAttachState {
  final int kode;
  // handle for checklist user

  UploadAttachStateSuccess({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}
