import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/repositories/task_repository.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final TaskRepository repository;
  DatabaseBloc(this.repository) : super(DatabaseInitial()) {
    on<AddEvent>(_add);
    on<DeleteEvent>(_delete);
    on<UpdateEvent>(_update);
    on<FeatchedEvent>(_featched);
  }

  FutureOr<void> _add(AddEvent event, Emitter<DatabaseState> emit) async {
    emit(DatabaseLoading());

    repository.addTask(event.title, event.description);
    emit(DatabaseLoaded(await repository.getTasks()));
  }

  FutureOr<void> _delete(DeleteEvent event, Emitter<DatabaseState> emit) async {
    emit(DatabaseLoading());
    repository.deleteTask(event.sn);
    List<Map<String, dynamic>> data = await repository.getTasks();
    if (data.isEmpty) {
      emit(DatabaseEmpty());
    } else {
      emit(DatabaseLoaded(data));
    }
  }

  FutureOr<void> _update(UpdateEvent event, Emitter<DatabaseState> emit) async {
    emit(DatabaseLoading());
    repository.updateTask(event.sn, event.title, event.description, event.isTrue);
    emit(DatabaseLoaded(await repository.getTasks()));
  }

  FutureOr<void> _featched(FeatchedEvent event, Emitter<DatabaseState> emit) async {
    emit(DatabaseLoading());
    List<Map<String, dynamic>> data = await repository.getTasks();
    if (data.isEmpty) {
      emit(DatabaseEmpty());
    } else {
      emit(DatabaseLoaded(data));
    }
  }
}
