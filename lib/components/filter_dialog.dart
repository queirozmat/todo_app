import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app/bloc/home_bloc/home_bloc.dart';

import '../others/util.dart';

class FilterDialog extends StatefulWidget {
  final VoidCallback onClear;
  final VoidCallback onApply;
  final HomeBloc homeBloc;

  const FilterDialog({
    Key? key,
    required this.onClear,
    required this.onApply,
    required this.homeBloc,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Tarefas'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Status'),
                    value: widget.homeBloc.statusFilter,
                    onChanged: (value) {
                      setState(() {
                        widget.homeBloc.statusFilter = value!;
                      });
                    },
                    items: <String>[
                      'A Realizar',
                      'Realizada',
                      'Cancelada',
                      'Aguardando Avaliação',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
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
                        widget.homeBloc.startDateFilterController.text =
                            Util.formatarData(
                          date.toString(),
                          dataHora: false,
                        );
                      });
                    },
                  );
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: widget.homeBloc.startDateFilterController,
                    decoration: InputDecoration(
                      labelText: 'Data de Início',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
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
                        widget.homeBloc.endDateFilterController.text =
                            Util.formatarData(
                          date.toString(),
                          dataHora: false,
                        );
                      });
                    },
                  );
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: widget.homeBloc.endDateFilterController,
                    decoration: InputDecoration(
                      labelText: 'Data de Término',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onClear,
          child: const Text('Limpar Filtros'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: widget.onApply,
          child: const Text('Filtrar'),
        ),
      ],
    );
  }
}
