import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/components/card_todo.dart';
import 'package:todo_app/components/filter_dialog.dart';
import 'package:todo_app/components/search_bar.dart';
import 'package:todo_app/others/nav.dart';
import 'package:todo_app/pages/register_todo_page.dart';

import '../bloc/home_bloc/home_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HomeBloc homeBloc;
  late TodoBloc todoBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    todoBloc = BlocProvider.of<TodoBloc>(context);
    homeBloc.add(const TodoGetListEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoDeleteLoadingState ||
            (state is TodoPutLoadingState && state.cancelEditHome == true)) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(state is TodoDeleteLoadingState
                    ? 'Excluindo Tarefa'
                    : 'Atualizando Tarefa'),
                content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        } else if (state is TodoErrorState) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is TodoDeleteLoadedState ||
            (state is TodoPutLoadedState && state.cancelEditHome == true)) {
          homeBloc.add(const TodoGetListEvent());

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state is TodoDeleteLoadedState
                  ? 'Tarefa excluída com sucesso!'
                  : 'Tarefa atualizada com sucesso!'),
            ),
          );
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            homeBloc.add(const TodoGetListEvent());
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MySearchBar(
                  onChanged: (value) {
                    homeBloc.add(TodoSearchListEvent(value));
                  },
                  hintText: 'Pesquisar',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Lista de Tarefas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return FilterDialog(
                                  onClear: () {
                                    setState(() {
                                      homeBloc.statusFilter = null;
                                      homeBloc.startDateFilterController
                                          .clear();
                                      homeBloc.endDateFilterController.clear();
                                    });
                                  },
                                  onApply: () {
                                    Navigator.pop(context);
                                    homeBloc.add(const TodoFilterListEvent());
                                  },
                                  homeBloc: homeBloc,
                                );
                                //
                              });
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    bloc: homeBloc,
                    builder: (contex, state) {
                      if (state is TodoListLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is TodoListErrorState) {
                        return const Center(
                          child: Text('Erro ao carregar lista de tarefas'),
                        );
                      }

                      if (state is TodoListLoadedState) {
                        if (state.todoList.isEmpty) {
                          return const Center(
                            child: Text('Nenhuma tarefa cadastrada'),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state.todoList.length,
                          itemBuilder: (context, index) {
                            final todo = state.todoList[index];

                            return CardTodo(
                              todo: todo,
                              todoBloc: BlocProvider.of<TodoBloc>(context),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        push(context, const RegisterTodoPage());
                      },
                      tooltip: 'Adicionar',
                      child: const Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
