import 'package:equatable/equatable.dart';
import 'package:task_manager/models/todo_model.dart';

// States
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final bool hasReachedMax;

  const TodoLoaded({
    required this.todos,
    required this.hasReachedMax,
  });

  TodoLoaded copyWith({
    List<Todo>? todos,
    bool? hasReachedMax,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [todos, hasReachedMax];
}

class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object> get props => [message];
}

class TodoMessage extends TodoState {
  final String message;

  const TodoMessage({required this.message});

  @override
  List<Object> get props => [message];
}
