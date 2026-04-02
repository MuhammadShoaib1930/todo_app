part of 'database_bloc.dart';

sealed class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

final class DatabaseInitial extends DatabaseState {}

final class DatabaseLoaded extends DatabaseState {
  final List<Map<String, dynamic>> data;
  const DatabaseLoaded(this.data);
  @override
  List<Object> get props => [data];
}

final class DatabaseError extends DatabaseState {
  final String message;
  const DatabaseError(this.message);
  @override
  List<Object> get props => [message];
}

final class DatabaseLoading extends DatabaseState {}

final class DatabaseEmpty extends DatabaseState {}
