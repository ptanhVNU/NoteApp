import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  String title;
  String description;
  final Timestamp date;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    return Task(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        date: snapshot['date']);
  }

  static Task fromJson(Map<String, dynamic> json) => Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'] as Timestamp);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date,
      };
}
