import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/repository/repository.dart';

class TodoApi extends Repository {
  Future<List<TodoModel>> getTodoList() async {
    Uri uri = getUriAPI('/tarefas');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final listMap = jsonDecode(response.body);

        return listMap
            .map<TodoModel>((json) => TodoModel.fromJson(json))
            .toList();
      } else {
        throw 'Erro ao carregar lista de tarefas';
      }
    } catch (e) {
      throw 'Erro ao carregar lista de tarefas';
    }
  }

  Future<TodoModel> postTodoList(TodoModel todo) async {
    Uri uri = getUriAPI('/tarefas');

    try {
      final response = await http.post(
        uri,
        headers: getHeaderDefault(),
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return TodoModel.fromJson(json);
      } else {
        throw 'Erro ao salvar tarefa';
      }
    } catch (e) {
      throw 'Erro ao salvar tarefa';
    }
  }

  Future<TodoModel> putTodoList(TodoModel todo) async {
    Uri uri = getUriAPI('/tarefas');

    try {
      final body = jsonEncode(todo.toJson());

      final response = await http.put(
        uri,
        headers: getHeaderDefault(),
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return TodoModel.fromJson(json);
      } else {
        throw 'Erro ao atualizar tarefa';
      }
    } catch (e) {
      throw 'Erro ao atualizar tarefa';
    }
  }

  Future<void> deleteTodoList(int id) async {
    Uri uri = getUriAPI('/tarefas', queryParams: {'id': id.toString()});

    try {
      final response = await http.delete(
        uri,
        headers: getHeaderDefault(),
      );

      if (response.statusCode != 204) {
        throw 'Erro ao deletar tarefa';
      }
    } catch (e) {
      throw 'Erro ao deletar tarefa';
    }
  }
}
