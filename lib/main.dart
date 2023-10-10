import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/home_bloc/home_bloc.dart';
import 'package:todo_app/pages/home_page.dart';

import 'bloc/todo_bloc/todo_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF000000,
            <int, Color>{
              50: Color(0xFFE0E0E0),
              100: Color(0xFFB0B0B0),
              200: Color(0xFF808080),
              300: Color(0xFF505050),
              400: Color(0xFF303030),
              500: Color(0xFF000000),
              600: Color(0xFF000000),
              700: Color(0xFF000000),
              800: Color(0xFF000000),
              900: Color(0xFF000000),
            },
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
