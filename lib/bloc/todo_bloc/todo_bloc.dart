import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/repository/todo_api.dart';

import '../../models/todo_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoApi todoApi = TodoApi();

  TodoBloc() : super(TodoInitialState()) {
    on<TodoPostEvent>(
      (event, emit) async {
        try {
          emit(TodoPostLoadingState());

          await todoApi.postTodoList(event.todo);

          emit(TodoPostLoadedState());
        } catch (e) {
          emit(TodoErrorState(e.toString()));
        }
      },
    );

    on<TodoPutEvent>(
      (event, emit) async {
        try {
          emit(TodoPutLoadingState(cancelEditHome: event.canEditHome));

          await todoApi.putTodoList(event.todo);

          await Future.delayed(const Duration(seconds: 2));
          emit(TodoPutLoadedState(cancelEditHome: event.canEditHome));
        } catch (e) {
          emit(TodoErrorState(e.toString()));
        }
      },
    );

    on<TodoDeleteEvent>(
      (event, emit) async {
        try {
          emit(TodoDeleteLoadingState());

          await todoApi.deleteTodoList(event.id);

          await Future.delayed(const Duration(seconds: 2));

          emit(TodoDeleteLoadedState());
        } catch (e) {
          emit(TodoErrorState(e.toString()));
        }
      },
    );
  }
}
