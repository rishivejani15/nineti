import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({required this.todo, super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.todo),
      trailing: Icon(
        todo.completed ? Icons.check_circle : Icons.circle_outlined,
      ),
    );
  }
}
