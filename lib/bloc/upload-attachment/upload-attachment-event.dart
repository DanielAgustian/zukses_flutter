import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

abstract class UploadAttachEvent extends Equatable {
  const UploadAttachEvent();

  List<Object> get props => [];
}

// Load all employee data
class UploadAttachNewEvent extends UploadAttachEvent {
  final String idTask;
  final File image;
  UploadAttachNewEvent(this.idTask, this.image);
  List<Object> get props => [];
}
