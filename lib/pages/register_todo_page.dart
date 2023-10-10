import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/home_bloc/home_bloc.dart';
import 'package:todo_app/bloc/todo_bloc/todo_bloc.dart';
import 'package:todo_app/others/util.dart';

import '../components/data_field.dart';
import '../components/time_field.dart';
import '../models/todo_model.dart';

class RegisterTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const RegisterTodoPage({super.key, this.todo});

  @override
  RegisterTodoPageState createState() => RegisterTodoPageState();
}

class RegisterTodoPageState extends State<RegisterTodoPage> {
  final TodoModel _todoModel = TodoModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();

  final TextEditingController _dataTerminoController = TextEditingController();
  final TextEditingController _horaTerminoController = TextEditingController();

  DateTime? startDateTime;
  DateTime? endDateTime;

  TimeOfDay? _horaInicio;
  TimeOfDay? _horaTermino;

  @override
  void initState() {
    if (widget.todo != null) {
      _todoModel.id = widget.todo!.id;
      _todoModel.tarefa = widget.todo!.tarefa;
      _todoModel.status = widget.todo!.status;
      _todoModel.dataInicio = widget.todo!.dataInicio;
      _todoModel.dataTermino = widget.todo!.dataTermino;
      _todoModel.observacao = widget.todo!.observacao;

      _dataInicioController.text = Util.formatarData(
        widget.todo!.dataInicio!,
        dataHora: false,
      );

      _dataTerminoController.text = Util.formatarData(
        widget.todo!.dataTermino!,
        dataHora: false,
      );

      _horaInicio = TimeOfDay.fromDateTime(
        DateTime.parse(widget.todo!.dataInicio!),
      );

      _horaTermino = TimeOfDay.fromDateTime(
        DateTime.parse(widget.todo!.dataTermino!),
      );
    }

    super.initState();
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecione uma data';
    }
    return null;
  }

  String? validateTime(TimeOfDay? time) {
    if (time == null) {
      return 'Selecione um horário';
    }
    return null;
  }

  String? _validateDateRange() {
    final String startDate = _dataInicioController.text;
    final String endDate = _dataTerminoController.text;

    if (startDate.isEmpty ||
        endDate.isEmpty ||
        _horaInicio == null ||
        _horaTermino == null) {
      return 'Preencha todas as datas e horários';
    }

    startDateTime = Util.convertStringToDate(startDate);
    endDateTime = Util.convertStringToDate(endDate);

    startDateTime = DateTime(startDateTime!.year, startDateTime!.month,
        startDateTime!.day, _horaInicio?.hour ?? 0, _horaInicio?.minute ?? 0);

    endDateTime = DateTime(endDateTime!.year, endDateTime!.month,
        endDateTime!.day, _horaTermino?.hour ?? 0, _horaTermino?.minute ?? 0);

    if (startDateTime!.isAfter(endDateTime!)) {
      return 'Data de início não pode ser maior que a data de término';
    }

    return null;
  }

  Future<void> _selectHoraInicio(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaInicio ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _horaInicio = picked;
        _horaInicioController.text = _horaInicio!.format(context);
      });
    }
  }

  Future<void> _selectHoraTermino(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaTermino ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(
        () {
          _horaTermino = picked;
          _horaTerminoController.text = _horaTermino!.format(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todo != null) {
      _horaInicioController.text = _horaInicio?.format(context) ?? '';
      _horaTerminoController.text = _horaTermino?.format(context) ?? '';
    }

    TodoBloc todoBloc = BlocProvider.of<TodoBloc>(context);
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoPostLoadedState || state is TodoPutLoadedState) {
          homeBloc.add(const TodoGetListEvent());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state is TodoPostLoadedState
                  ? 'Tarefa cadastrada com sucesso!'
                  : 'Tarefa atualizada com sucesso!'),
            ),
          );

          Navigator.pop(context);
        }

        if (state is TodoErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.todo != null ? 'Editar Tarefa' : 'Cadastrar Tarefa'),
          actions: [
            IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String? dateRangeError = _validateDateRange();

                  if (dateRangeError == null) {
                    _formKey.currentState!.save();

                    if (widget.todo != null) {
                      _todoModel.id = widget.todo!.id;
                      _todoModel.dataInicio = DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(startDateTime!);
                      _todoModel.dataTermino = DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(endDateTime!);

                      todoBloc.add(TodoPutEvent(_todoModel));
                    } else {
                      _todoModel.id = 0;
                      _todoModel.dataInicio = DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(startDateTime!);
                      _todoModel.dataTermino = DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(endDateTime!);
                      _todoModel.status = 'A Realizar';

                      todoBloc.add(TodoPostEvent(_todoModel));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(dateRangeError),
                      ),
                    );
                  }
                }
              },
              icon: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoPostLoadingState ||
                      state is TodoPutLoadingState) {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  return const Icon(Icons.save);
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  if (widget.todo != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: IgnorePointer(
                              child: TextFormField(
                                initialValue: _todoModel.id.toString(),
                                decoration: InputDecoration(
                                  labelText: 'ID',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                child: DropdownButton<String>(
                                  value: _todoModel.status,
                                  onChanged: (value) {
                                    setState(() {
                                      _todoModel.status = value!;
                                    });
                                  },
                                  items: <String>[
                                    'A Realizar',
                                    'Realizada',
                                    'Cancelada',
                                    'Aguardando Avaliação',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextFormField(
                    initialValue: _todoModel.tarefa,
                    decoration: InputDecoration(
                      labelText: 'Tarefa',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSaved: (value) {
                      _todoModel.tarefa = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o nome da tarefa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      DateField(
                        controller: _dataInicioController,
                        labelText: 'Data de Início',
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2000),
                            maxTime: DateTime(2030),
                            locale: LocaleType.pt,
                            currentTime: DateTime.now(),
                            onConfirm: (date) {
                              date = DateTime(date.year, date.month, date.day);

                              setState(() {
                                _dataInicioController.text = Util.formatarData(
                                  date.toString(),
                                  dataHora: false,
                                );
                              });
                            },
                          );
                        },
                        validator: validateDate,
                      ),
                      const SizedBox(width: 10),
                      TimeField(
                        controller: _horaInicioController,
                        labelText: 'Horário de Início',
                        onTap: () {
                          _selectHoraInicio(context);
                        },
                        validator: (value) => validateTime(_horaInicio),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      DateField(
                        controller: _dataTerminoController,
                        labelText: 'Data de Término',
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2000),
                            maxTime: DateTime(2030),
                            locale: LocaleType.pt,
                            currentTime: DateTime.now(),
                            onConfirm: (date) {
                              date = DateTime(date.year, date.month, date.day);

                              setState(() {
                                _dataTerminoController.text = Util.formatarData(
                                  date.toString(),
                                  dataHora: false,
                                );
                              });
                            },
                          );
                        },
                        validator: validateDate,
                      ),
                      const SizedBox(width: 10),
                      TimeField(
                        controller: _horaTerminoController,
                        labelText: 'Horário de Término',
                        onTap: () {
                          _selectHoraTermino(context);
                        },
                        validator: (value) => validateTime(_horaTermino),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: TextFormField(
                      initialValue: _todoModel.observacao,
                      maxLines: 5,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Observação',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSaved: (value) {
                        _todoModel.observacao = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
