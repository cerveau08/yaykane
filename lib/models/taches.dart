class TaskModel {
  final String id;
  final String name;
  final DateTime createdAt;

  TaskModel({required this.id, required this.name, required this.createdAt});

  factory TaskModel.fromMap(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      name: data['name'],
      createdAt: (data['created_at']).toDate(),
    );
  }
}
