import 'package:equatable/equatable.dart';

abstract class ListCSVEvent extends Equatable {
  const ListCSVEvent();

  List<Object> get props => [];
}

class ListCSVGetListEvent extends ListCSVEvent {
  ListCSVGetListEvent();
  List<Object> get props => [];
}

class ListCSVDeleteEvent extends ListCSVEvent {
  final String conversationId;
  ListCSVDeleteEvent({this.conversationId});
  List<Object> get props => [];
}
