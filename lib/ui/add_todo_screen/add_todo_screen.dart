import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_event.dart';
import 'package:task_manager/bloc/todo_bloc/todo_state.dart';
import 'package:task_manager/models/todo_model.dart';
import 'package:task_manager/repositories/auth_repository.dart';

class AddToDoScreen extends StatefulWidget {
  const AddToDoScreen({super.key});

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final todoController = TextEditingController();
  bool _isCompleted = false; // Initially set to false (Pending)
  final authRepository = AuthRepository();
  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              controller: todoController,
              decoration: const InputDecoration(
                  hintText: 'Todo', border: OutlineInputBorder()),
            ),
            RadioListTile(
              title: const Text('Completed'),
              value: true,
              groupValue: _isCompleted,
              onChanged: (value) => setState(() => _isCompleted = value!),
            ),
            RadioListTile(
              title: const Text('Pending'),
              value: false,
              groupValue: _isCompleted,
              onChanged: (value) => setState(() => _isCompleted = value!),
            ),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    Todo todo = Todo(
                        todo: todoController.text,
                        completed: _isCompleted,
                        userId: AuthRepository.user.id);
                    BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
                    todoController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text('Save'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
