import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/message-type-model.dart';

abstract class MessageTypeEvent extends Equatable {
  const MessageTypeEvent();

  List<Object> get props => [];
}

class GetMessageTypeEvent extends MessageTypeEvent {
 

  GetMessageTypeEvent();
  List<Object> get props => [];
}
