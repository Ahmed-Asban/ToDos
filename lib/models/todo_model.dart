import 'package:flutter/material.dart';

class Todo {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final List<String> tags;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    DateTime? createdAt,
    this.dueDate,
    this.priority = Priority.medium,
    this.tags = const [],
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'tags': tags,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: Priority.values[map['priority']],
      tags: List<String>.from(map['tags']),
      isCompleted: map['isCompleted'],
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    Priority? priority,
    List<String>? tags,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum Priority { low, medium, high }

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case Priority.low:
        return Icons.arrow_downward;
      case Priority.medium:
        return Icons.remove;
      case Priority.high:
        return Icons.arrow_upward;
    }
  }
}
