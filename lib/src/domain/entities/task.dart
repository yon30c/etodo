import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id? id;
  String title;
  String? details;
  DateTime? dateTime;
  String? time;
  bool isCompleted;
  bool isHighPriority;

  Task({
    required this.id,
    required this.title,
    required this.details,
    this.dateTime,
    this.isCompleted = false,
    this.isHighPriority = false,
  });
}

