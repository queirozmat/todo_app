part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class TodoInitialState extends HomeState {}

class TodoListLoadingState extends HomeState {}

class TodoListLoadedState extends HomeState {
  final List<TodoModel> todoList;

  const TodoListLoadedState(this.todoList);

  @override
  List<Object> get props => [todoList];
}

class TodoListErrorState extends HomeState {
  final String message;

  const TodoListErrorState(this.message);

  @override
  List<Object> get props => [message];
}
