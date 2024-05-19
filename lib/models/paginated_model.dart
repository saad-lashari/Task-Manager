import 'package:task_manager/models/todo_model.dart';

class PaginatedTodos {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  PaginatedTodos({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PaginatedTodos.fromJson(Map<String, dynamic> json) {
    return PaginatedTodos(
      todos:
          (json['todos'] as List).map((todo) => Todo.fromJson(todo)).toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
