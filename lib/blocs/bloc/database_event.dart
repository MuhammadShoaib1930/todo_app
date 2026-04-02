part of 'database_bloc.dart';

sealed class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

final class AddEvent extends DatabaseEvent {
  final String title;
  final String description;
  const AddEvent(this.title, this.description);
  @override
  List<Object> get props => [title, description];
}

final class UpdateEvent extends DatabaseEvent {
  final int sn;
  final String title;
  final String description;
  final int isTrue;
  const UpdateEvent(this.sn, this.title, this.description,this.isTrue);
  @override
  List<Object> get props => [sn, title, description,isTrue];
}

final class DeleteEvent extends DatabaseEvent {
  final int sn;
  const DeleteEvent(this.sn);
  @override
  List<Object> get props => [sn];
}
final class FeatchedEvent extends DatabaseEvent{}
