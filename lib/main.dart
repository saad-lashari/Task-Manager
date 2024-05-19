import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_bloc.dart';
import 'package:task_manager/bloc/todo_bloc/todo_event.dart';
import 'package:task_manager/repositories/auth_repository.dart';
import 'package:task_manager/ui/add_todo_screen/add_todo_screen.dart';
import 'package:task_manager/ui/auth_screen/login_screen.dart';
import 'package:task_manager/ui/todo_screen/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthRepository.getUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc()..add(FetchTodos()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AuthRepository.user.email.isEmpty ? '/' : '/home',
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const TodoPage(),
          '/addToDo': (context) => const AddToDoScreen()
        },
      ),
    );
  }
}
