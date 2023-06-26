import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class TasksView extends ConsumerStatefulWidget {
  static const String name = 'task-screen';

  const TasksView({super.key});

  @override
  TasksViewState createState() => TasksViewState();
}

class TasksViewState extends ConsumerState<TasksView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() async {
    if (isLoading) return;
    isLoading = true;

    await ref.read(taskProvider).loadTask();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider).tasks;
    final textStyle = Theme.of(context).textTheme;

    if (tasks.isEmpty) {
      return FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Image.asset(
                'assets/tk.png',
                height: 180,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'No hay tareas aún',
              style: textStyle.titleLarge,
            ),
            const Text('Agrega tareas pendientes'),
            const SizedBox(
              height: 35,
            )
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskDetails(
            task: task,
          );
        });
  }
}
