part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class TodoGetListEvent extends HomeEvent {
  const TodoGetListEvent();
}

class TodoSearchListEvent extends HomeEvent {
  final String search;

  const TodoSearchListEvent(this.search);

  @override
  List<Object> get props => [search];
}

class TodoFilterListEvent extends HomeEvent {
  const TodoFilterListEvent();
}
