import '../../domain/domain.dart';

class TaskRepositoryImpl extends TasksRepository {
  final TasksDatasource datasource;

  TaskRepositoryImpl(this.datasource);
  @override
  Future<bool> completeTask(Task task) {
    return datasource.completeTask(task);
  }

  @override
  Future<void> deleteTask(Task task) {
    return datasource.deleteTask(task);
  }

  @override
  Future<List<Task>> loadTaks() {
    return datasource.loadTaks();
  }

  @override
  Future<void> togglePriority(Task task) {
    return datasource.togglePriority(task);
  }

  @override
  Future<void> saveTask(Task task) {
    return datasource.saveTask(task);
  }

  @override
  Future updateTask(Task task) {
    return datasource.updateTask(task);
  }

  @override
  Future saveOrUpdateTask(Task task) {
    return datasource.saveOrUpdateTask(task);
  }

  @override
  Future<void> toggleCompleted(Task task) {
    return datasource.toggleCompleted(task);
  }

  @override
  Future<List<Task>> loadPriorityTask() {
    return datasource.loadPriorityTask();
  }

  @override
  Future<bool> priorityTask(Task task) {
    return datasource.priorityTask(task);
  }

  @override
  Future<List<Task>> loadCompletedTask() {
    return datasource.loadCompletedTask();
  }

  @override
  Future<void> deleteAllCompleted() {
    return datasource.deleteAllCompleted();
  }

  @override
  Future<void> toggleAllCompleted(List<Task> task) {
    return datasource.toggleAllCompleted(task);
  }
}
