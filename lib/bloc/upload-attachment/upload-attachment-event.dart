import 'dart:io';
import 'package:equatable/equatable.dart';

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

class UploadAttachGetEvent extends UploadAttachEvent {
  final String idTask;
 
  UploadAttachGetEvent(this.idTask);
  List<Object> get props => [];
}