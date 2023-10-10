import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/others/util.dart';
import 'package:todo_app/repository/todo_api.dart';

import '../../models/todo_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TodoApi todoApi = TodoApi();
  List<TodoModel> todoList = [];

  String? statusFilter;
  TextEditingController startDateFilterController = TextEditingController();
  TextEditingController endDateFilterController = TextEditingController();

  HomeBloc() : super(TodoInitialState()) {
    on<TodoGetListEvent>(
      (event, emit) async {
        try {
          emit(TodoListLoadingState());

          todoList = await todoApi.getTodoList();

          emit(TodoListLoadedState(todoList));
        } catch (e) {
          emit(TodoListErrorState(e.toString()));
        }
      },
    );

    on<TodoSearchListEvent>(
      (event, emit) async {
        try {
          emit(TodoListLoadingState());

          List<TodoModel> searchList = todoList.where((todo) {
            final title = todo.tarefa!.toLowerCase();
            final search = event.search.toLowerCase();

            return title.contains(search);
          }).toList();

          emit(TodoListLoadedState(searchList));
        } catch (e) {
          emit(TodoListErrorState(e.toString()));
        }
      },
    );

    on<TodoFilterListEvent>(
      (event, emit) async {
        try {
          emit(TodoListLoadingState());

          List<TodoModel> filterList = todoList;

          if (statusFilter != null) {
            filterList = filterList.where((todo) {
              final status = todo.status!.toLowerCase();
              final filter = statusFilter!.toLowerCase();

              return status.contains(filter);
            }).toList();
          }

          if (startDateFilterController.text.isNotEmpty) {
            filterList = filterList.where((todo) {
              final startDate = DateTime.parse(todo.dataInicio!);
              final filterDate =
                  Util.convertStringToDate(startDateFilterController.text);

              return startDate.isAfter(filterDate);
            }).toList();
          }

          if (endDateFilterController.text.isNotEmpty) {
            filterList = filterList.where((todo) {
              final endDate = DateTime.parse(todo.dataTermino!);

              DateTime filterDate =
                  Util.convertStringToDate(endDateFilterController.text);

              filterDate = DateTime(filterDate.year, filterDate.month,
                  filterDate.day, 23, 59, 59, 999, 999);

              return endDate.isBefore(filterDate);
            }).toList();
          }

          emit(TodoListLoadedState(filterList));
        } catch (e) {
          emit(TodoListErrorState(e.toString()));
        }
      },
    );
  }
}
