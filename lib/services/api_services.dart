import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:task_manager/models/paginated_model.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utils/app_constants.dart';

class ApiClient {
  ApiClient();
  static Future<PaginatedTodos> fetchTodos(int limit, int skip) async {
    final response =
        await http.get(Uri.parse('$baseUrl/todos?limit=$limit&skip=$skip'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PaginatedTodos.fromJson(json);
    } else {
      throw Exception('Failed to load todos');
    }
  }

  static Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  // static Future<List<Todo>> fetchTodos() async {
  //   User user = await LocalStorage.getUser();
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/todos/user/${user.id}'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body)['todos']; // Accessing 'todos' key
  //     List<Todo> todoList =
  //         data.map<Todo>((item) => Todo.fromJson(item)).toList();
  //     return todoList;
  //   } else {
  //     throw Exception('Failed to load todos');
  //   }
  // }

  static Future<Todo> addTodo(
    Todo todo,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'todo': todo.todo,
        'completed': todo.completed,
        'userId': todo.userId,
      }),
    );

    if (response.statusCode == 200) {
      log(response.body.toString());
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add todo');
    }
  }

  static Future<Todo> updateTodo(int id, String todo, bool completed) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'todo': todo,
        'completed': completed,
      }),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update todo');
    }
  }

  static Future<bool> deleteTodo(int id) async {
    bool isDeleted = false;
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      isDeleted = data['isDeleted'];
      return isDeleted;
    }
    return isDeleted;
  }
}
