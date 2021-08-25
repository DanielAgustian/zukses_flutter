import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/notif-model.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  List<Object> get props => [];
}

class ChangePasswordStateFailed extends ChangePasswordState {}
class ChangePasswordStateFailedDiffPass extends ChangePasswordState {}
class ChangePasswordStateSuccess extends ChangePasswordState {
  ChangePasswordStateSuccess();
  List<Object> get props => [];

  @override
  String toString() {
    return 'Data : { employee List: }';
  }
}



class ChangePasswordStateLoading extends ChangePasswordState {}
