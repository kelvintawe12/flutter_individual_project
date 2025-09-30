import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TimeOfDay? reminderTime;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      reminderTime: json['reminderTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['reminderTime'].split(":")[0]),
              minute: int.parse(json['reminderTime'].split(":")[1]),
            )
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'isCompleted': isCompleted,
    };
  }
}
