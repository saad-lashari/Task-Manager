import 'package:task_manager/local_storage/local_storage.dart';
import 'package:task_manager/models/paginated_model.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/services/api_services.dart';

class TodoRepository {
  static Future<PaginatedTodos> getTodos(int limit, int skip) async {
    // List<Todo> data = await LocalStorage.getTodoList();
    // if (data.isEmpty && AuthRepository.user.email.isNotEmpty) {
    PaginatedTodos paginatedTodos = await ApiClient.fetchTodos(limit, skip);
    await LocalStorage.saveTodoList(paginatedTodos.todos);
    // }
    return paginatedTodos;
  }

  static Future<Todo> addTodo(Todo todo) async {
    return await ApiClient.addTodo(todo);
  }

  static Future<Todo> updateTodo(int id, String todo, bool completed) async {
    return await ApiClient.updateTodo(id, todo, completed);
  }

  static Future<List<Todo>> deleteTodo(int id) async {
    List<Todo> todoData = await LocalStorage.getTodoList();
    bool apiDeleted = false;
    apiDeleted = await ApiClient.deleteTodo(id);
    if (apiDeleted) {
      todoData.removeWhere((todo) => todo.id == id);
      LocalStorage.saveTodoList(todoData);
    }
    return todoData;
  }
}
