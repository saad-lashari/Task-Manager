import 'package:equatable/equatable.dart';
import 'package:task_manager/models/todo_model.dart';

// Events
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class FetchTodos extends TodoEvent {}

class FetchMoreTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  final int id;
  final String todo;
  final bool completed;

  const UpdateTodo(this.id, this.todo, this.completed);

  @override
  List<Object> get props => [id, todo, completed];
}

class DeleteTodo extends TodoEvent {
  final int id;

  const DeleteTodo(this.id);

  @override
  List<Object> get props => [id];
}
