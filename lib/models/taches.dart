import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaykane/models/statut.dart';

class Tache {
  String id;
  String title;
  DateTime createdAt;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? endDateReel;
  bool? isCompleted;
  String? description;
  String assignedUserId;
  Statut statut;

  Tache({
    required this.id,
    required this.title,
    required this.createdAt,
    this.startDate,
    this.endDate,
    this.endDateReel,
    this.isCompleted,
    this.description,
    required this.assignedUserId,
    this.statut = Statut.enAttente
  });

  bool get isDeadlineMet {
    return DateTime.now().isBefore(endDate!);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createdAt': createdAt,
      'startDate': startDate,
      'endDate': endDate,
      'endDateReel': endDateReel,
      'isCompleted': isCompleted,
      'description': description,
      'assignedUserId': assignedUserId,
      'status': statut.index,
    };
  }

  factory Tache.fromMap(Map<String, dynamic> map, String id) {
    return Tache(
      id: id,
      title: map['title'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      endDateReel: (map['endDateReel'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'],
      description: map['description'],
      assignedUserId: map['assignedUserId'],
      statut: Statut.values[map['statut']],
    );
  }
}
