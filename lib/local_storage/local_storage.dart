import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/models/user_model.dart';

class LocalStorage {
  static late SharedPreferences _prefs;
  static Future<void> saveUser(User user) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('id', user.id);
    _prefs.setString('username', user.username);
    _prefs.setString('email', user.email);
    _prefs.setString('firstName', user.firstName);
    _prefs.setString('lastName', user.lastName);
    _prefs.setString('image', user.image);
    _prefs.setString('gender', user.gender);
  }

  static Future<User> getUser() async {
    _prefs = await SharedPreferences.getInstance();
    // _prefs.getInt('id');

    return User(
      id: _prefs.getInt('id') ?? 0,
      username: _prefs.getString('username') ?? '',
      email: _prefs.getString('email') ?? '',
      firstName: _prefs.getString('firstName') ?? '',
      lastName: _prefs.getString('lastName') ?? '',
      image: _prefs.getString('image') ?? '',
      gender: _prefs.getString('gender') ?? '',
    );
  }

  static Future<void> saveTodoList(List<Todo> todoList) async {
    _prefs = await SharedPreferences.getInstance();
    final List<String> serializedList =
        todoList.map((todo) => json.encode(todo.toJson())).toList();
    _prefs.setStringList('todoList', serializedList);
  }

  static Future<List<Todo>> getTodoList() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? serializedList = _prefs.getStringList('todoList');

    if (serializedList == null) {
      return [];
    }

    return serializedList.map((jsonString) {
      final Map<String, dynamic> map = json.decode(jsonString);
      return Todo.fromJson(map);
    }).toList();
  }
}
