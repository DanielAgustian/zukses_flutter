import 'package:equatable/equatable.dart';


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
