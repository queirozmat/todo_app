import 'package:flutter/material.dart';
import 'package:todo_app/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/others/nav.dart';
import 'package:todo_app/others/util.dart';
import 'package:todo_app/pages/register_todo_page.dart';

import '../models/todo_model.dart';

class CardTodo extends StatelessWidget {
  final TodoBloc todoBloc;
  final TodoModel todo;

  const CardTodo({super.key, required this.todo, required this.todoBloc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        push(context, RegisterTodoPage(todo: todo));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${todo.tarefa}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Status: '),
                            Text(
                              '${todo.status}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Data de Início: '),
                            Text(
                              Util.formatarData(todo.dataInicio!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Data de Término: '),
                            Text(
                              Util.formatarData(todo.dataTermino!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (todo.status == 'A Realizar')
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) {
                                return AlertDialog(
                                  title: const Text('Cancelar Tarefa'),
                                  content: const Text(
                                      'Deseja realmente cancelar a tarefa?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Não'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);

                                        todo.status = 'Cancelada';

                                        todoBloc.add(TodoPutEvent(todo,
                                            canEditHome: true));
                                      },
                                      child: const Text('Sim'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      if (todo.status == 'A Realizar')
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (c) {
                                return AlertDialog(
                                  title: const Text('Excluir Tarefa'),
                                  content: const Text(
                                      'Deseja realmente excluir a tarefa?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Não'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        todoBloc.add(TodoDeleteEvent(todo.id!));
                                      },
                                      child: const Text('Sim'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (todo.observacao != null && todo.observacao!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Observação:'),
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '${todo.observacao}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
