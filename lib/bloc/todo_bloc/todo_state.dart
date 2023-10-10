part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitialState extends TodoState {}

class TodoPostLoadingState extends TodoState {}

class TodoPostLoadedState extends TodoState {}

class TodoErrorState extends TodoState {
  final String message;

  const TodoErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TodoPutLoadingState extends TodoState {
  final bool? cancelEditHome;

  const TodoPutLoadingState({this.cancelEditHome});
}

class TodoPutLoadedState extends TodoState {
  final bool? cancelEditHome;

  const TodoPutLoadedState({this.cancelEditHome});
}

class TodoDeleteLoadingState extends TodoState {}

class TodoDeleteLoadedState extends TodoState {}
