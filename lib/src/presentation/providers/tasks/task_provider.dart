import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart';

import '../../../domain/domain.dart';
import '../providers.dart';

final taskProvider = ChangeNotifierProvider((ref) {
  final taskRepository = ref.watch(taskRepoProvider);
  return TaskNotifier(taskRepository);
});

class TaskNotifier extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Task> tasks = [];
  List<Task> prioriTasks = [];
  List<Task> completTasks = [];
  bool isPriorityTask = false;

  TZDateTime? time;

  void getDateTime(DateTime date, TimeOfDay hour) {
    time = TZDateTime(
        local, date.year, date.month, date.day, hour.hour, hour.minute);
  }

  Task createTask() {
    return Task(
      id: (tasks.length + completTasks.length + 1),
      title: '',
      details: null,
      isHighPriority: isPriorityTask,
      dateTime: time,
    );
  }

  final TasksRepository tasksRepository;

  TaskNotifier(this.tasksRepository) {
    loadTask();
    createTask();
  }

  //* Load tasks methods

  Future<void> loadTask() async {
    tasks = await tasksRepository.loadTaks();
    notifyListeners();
  }

  Future<List<Task>> loadPriorityTask() async {
    prioriTasks = await tasksRepository.loadPriorityTask();
    notifyListeners();
    return prioriTasks;
  }

  Future<List<Task>> loadCompletedTask() async {
    completTasks = await tasksRepository.loadCompletedTask();
    notifyListeners();
    return completTasks;
  }

  //* Save - update - delete

  Future saveOrUpdateTask(Task task) async {
    await tasksRepository.saveOrUpdateTask(task);
  }

  Future deleteTask(Task task) async {
    if (task.isCompleted) {
      completTasks.remove(task);
    }
    await tasksRepository.deleteTask(task);
    notifyListeners();
  }

  updatePriority(bool value) {
    isPriorityTask = value;
    notifyListeners();
  }

  Future deleteAllCompleted() async {
    completTasks.clear();
    await tasksRepository.deleteAllCompleted();
    notifyListeners();
  }

  //* Toggle methods

  Future<void> togglePriority(Task task) async {
    await tasksRepository.togglePriority(task);
    notifyListeners();
  }

  Future<void> toggleCompleted(Task task) async {
    if (task.isCompleted) {
      completTasks.remove(task);
    }
    tasks.remove(task);
    prioriTasks.remove(task);
    await tasksRepository.toggleCompleted(task);
    // await loadTask();
    notifyListeners();
  }

  Future<void> toggleAllCompleted() async {
    await tasksRepository.toggleAllCompleted(tasks);
    tasks.clear();
    notifyListeners();
  }
}
