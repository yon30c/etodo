import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/src/domain/entities/task.dart';
import '/src/presentation/providers/tasks/task_provider.dart';

class CompletedTask extends ConsumerStatefulWidget {
  const CompletedTask({super.key, required this.task});

  final Task task;

  @override
  CompletedTaskState createState() => CompletedTaskState();
}

class CompletedTaskState extends ConsumerState<CompletedTask> {
  @override
  void initState() {
    super.initState();
    ref.read(taskProvider).loadTask();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final textStyle = Theme.of(context).textTheme;
    return ListTile(
      title: Text(
        widget.task.title,
        style: textStyle.titleLarge!.copyWith(
            decoration: TextDecoration.combine([TextDecoration.lineThrough])),
      ),
      leading: const Icon(Icons.done),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text('Eliminar'),
                onTap: () async {
                  await ref
                      .read(taskProvider)
                      .deleteTask(widget.task)
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                  // ref.refresh(taskProvider).loadTask();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                leading: const Icon(Icons.cancel),
                title: const Text('Marcas como no completada'),
                onTap: () async {
                  await ref
                      .read(taskProvider)
                      .toggleCompleted(widget.task)
                      .then((value) {
                    Navigator.of(context).pop();
                  });

                  // ref.refresh(taskProvider).loadTask();

                  // ref.read(taskProvider.notifier).completTasks.remove(widget.task);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
