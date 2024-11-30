import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String email;
  final VoidCallback onDelete;

  const UserTile({required this.email, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(email),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
