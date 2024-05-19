import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_event.dart';
import 'package:task_manager/bloc/todo_bloc/todo_state.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Todos'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial || state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No tasks available'));
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !state.hasReachedMax) {
                  context.read<TodoBloc>().add(FetchMoreTodos());
                }
                return false;
              },
              child: ListView.builder(
                itemCount: state.hasReachedMax
                    ? state.todos.length
                    : state.todos.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.todos.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final todo = state.todos[index];
                  return ListTile(
                    subtitle: Text(todo.completed ? 'Completed ' : 'Pending'),
                    title: Text(todo.todo),
                    trailing: PopupMenuButton<String>(
                      offset: const Offset(50, -100),
                      onSelected: (value) async {
                        if (value == 'edit') {
                        } else if (value == 'delete') {
                          context.read<TodoBloc>().add(DeleteTodo(todo.id!));
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'update',
                          child: Text('Update'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addToDo');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
