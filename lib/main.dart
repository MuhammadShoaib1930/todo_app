import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/bloc/database_bloc.dart';
import 'package:todo_app/data/sqlflite_service.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:todo_app/ui/deshboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => TaskRepository(SqlfliteService()),
        child: BlocProvider(
          create: (context) => DatabaseBloc(context.read<TaskRepository>()),
          child: DeshboardPage(),
        ),
      ),
    );
  }
}
