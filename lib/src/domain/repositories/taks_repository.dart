
import '../domain.dart';

abstract class TasksRepository {
  Future<List<Task>> loadTaks();
  Future<void> deleteTask(Task task);
  Future<void> saveTask(Task task);
  Future<bool> completeTask(Task task);
  Future<void> togglePriority(Task task);
  Future updateTask(Task task);
  Future saveOrUpdateTask(Task task);
  Future<void> toggleCompleted(Task task);
  Future<List<Task>> loadPriorityTask();
  Future<List<Task>> loadCompletedTask();
  Future<bool> priorityTask(Task task);
  Future<void> deleteAllCompleted();
  Future<void> toggleAllCompleted(List<Task> task);

}
