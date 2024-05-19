import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_event.dart';
import 'package:task_manager/bloc/todo_bloc/todo_state.dart';
import 'package:task_manager/repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  static const int limit = 10;
  // final TodoTodoRepository TodoRepository;

  TodoBloc() : super(TodoInitial()) {
    on<FetchTodos>(_onFetchTodos);
    on<FetchMoreTodos>(_onFetchMoreTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final data = await TodoRepository.getTodos(limit, 0);
      emit(TodoLoaded(
          todos: data.todos, hasReachedMax: data.todos.length >= data.total));
    } catch (message) {
      emit(TodoError(message: message.toString()));
    }
  }

  Future<void> _onFetchMoreTodos(
      FetchMoreTodos event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      if (currentState.hasReachedMax) return;

      try {
        final data =
            await TodoRepository.getTodos(limit, currentState.todos.length);
        emit(data.todos.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : TodoLoaded(
                todos: currentState.todos + data.todos,
                hasReachedMax: currentState.todos.length + data.todos.length >=
                    data.total));
      } catch (message) {
        emit(TodoError(message: message.toString()));
      }
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await TodoRepository.addTodo(event.todo);
      emit(const TodoMessage(message: 'Todo added successfully'));
      add(FetchTodos());
    } catch (message) {
      emit(TodoError(message: message.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await TodoRepository.updateTodo(event.id, event.todo, event.completed);
      add(FetchTodos());
    } catch (message) {
      emit(TodoError(message: message.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await TodoRepository.deleteTodo(event.id);
      emit(TodoMessage(message: 'Todo deleted successfully'));
      add(FetchTodos());
    } catch (message) {
      emit(TodoError(message: message.toString()));
    }
  }
}
