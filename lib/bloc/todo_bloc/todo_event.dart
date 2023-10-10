part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoPostEvent extends TodoEvent {
  final TodoModel todo;

  const TodoPostEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class TodoPutEvent extends TodoEvent {
  final TodoModel todo;
  final bool? canEditHome;

  const TodoPutEvent(this.todo, {this.canEditHome});

  @override
  List<Object> get props => [todo];
}

class TodoDeleteEvent extends TodoEvent {
  final int id;

  const TodoDeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}
