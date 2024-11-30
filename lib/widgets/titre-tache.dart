import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final VoidCallback onDelete;

  const TaskTile({required this.taskName, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(taskName),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
