import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/domain.dart';

class IsarDatasource extends TasksDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([TaskSchema], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> deleteTask(Task task) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.tasks.deleteSync(task.id!));
  }

  @override
  Future<void> deleteAllCompleted() async {
    final isar = await db;

    final completedTask =
        await isar.tasks.filter().isCompletedEqualTo(true).findAll();
    List<int> completedTaskId = [];

    for (var element in completedTask) {
      completedTaskId.add(element.id!);
    }

    isar.writeTxn(() => isar.tasks.deleteAll(completedTaskId));
  }

  @override
  Future<void> saveTask(Task task) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.tasks.putSync(task));
  }

  @override
  Future updateTask(Task task) async {
    final isar = await db;
    Task? tk = await isar.tasks.get(task.id!);

    await isar.writeTxn(() async {
      tk!.title = task.title;
      tk.details = task.details;
      tk.dateTime = task.dateTime;
      tk.time = task.time;
      tk.isHighPriority = task.isHighPriority;

      await isar.tasks.put(tk);
    });
  }

  @override
  Future saveOrUpdateTask(Task task) async {
    final isar = await db;

    final tk = await isar.tasks.get(task.id!);
    if (tk != null) {
      await updateTask(task);
    } else {
      await saveTask(task);
    }
  }

  @override
  Future<bool> completeTask(Task task) async {
    final isar = await db;

    final tk = await isar.tasks.filter().idEqualTo(task.id).findFirst();

    return tk!.isCompleted;
  }

  @override
  Future<void> togglePriority(Task task) async {
    final isar = await db;

    final highPriorityTask = await isar.tasks.get(task.id!);

    if (highPriorityTask != null) {
      highPriorityTask.isHighPriority = !highPriorityTask.isHighPriority;

      isar.writeTxn(() => isar.tasks.put(highPriorityTask));
    }
  }

  @override
  Future<void> toggleCompleted(Task task) async {
    final isar = await db;

    final completedTaks = await isar.tasks.get(task.id!);

    if (completedTaks != null) {
      completedTaks.isCompleted = !completedTaks.isCompleted;

      isar.writeTxn(() => isar.tasks.put(completedTaks));
    }
  }

  @override
  Future<void> toggleAllCompleted(List<Task> task) async {
    final isar = await db;
    if (task.isEmpty) return;

    final tasksId = task.map((e) => e.id!).toList();
    final tasks = await isar.tasks.getAll(tasksId);

    for (var element in tasks) {
      element!.isCompleted = true;
      isar.writeTxn(() => isar.tasks.put(element));
    }
  }

  @override
  Future<bool> priorityTask(Task task) async {
    final isar = await db;

    final tk = await isar.tasks.filter().idEqualTo(task.id).findFirst();

    if (tk == null) {
      return task.isHighPriority;
    }
    return tk.isHighPriority;
  }

  //* Load tasks methods

  @override
  Future<List<Task>> loadTaks() async {
    final isar = await db;
    return isar.tasks.where().filter().isCompletedEqualTo(false).findAll();
  }

  @override
  Future<List<Task>> loadPriorityTask() async {
    final isar = await db;
    List<Task> priorityTask = await isar.tasks
        .filter()
        .isHighPriorityEqualTo(true)
        .isCompletedEqualTo(false)
        .findAll();

    return priorityTask;
  }

  @override
  Future<List<Task>> loadCompletedTask() async {
    final isar = await db;
    List<Task> completedTasks =
        await isar.tasks.where().filter().isCompletedEqualTo(true).findAll();
    return completedTasks;
  }
}
