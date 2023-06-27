import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:timezone/timezone.dart';

// import '../../../config/notifications/notifications.dart';
import '../../../../main.dart';
import '../../../domain/domain.dart';
import '../../providers/providers.dart';
import '../../views/views.dart';
import '../widgets.dart';

final isCompletedProvider = FutureProvider.family.autoDispose((ref, Task task) {
  final isarRepo = ref.watch(taskRepoProvider);
  return isarRepo.completeTask(task);
});

final isHighPriorityProvider =
    FutureProvider.family.autoDispose((ref, Task task) {
  final isarRepo = ref.watch(taskRepoProvider);
  return isarRepo.priorityTask(task);
});

class TaskDetails extends ConsumerWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, ref) {
    final color = Theme.of(context).colorScheme;
    final isCompletedFuture = ref.watch(isCompletedProvider(task));
    final isHighPriorityFuture = ref.watch(isHighPriorityProvider(task));

    return ListTile(
      title: Text(task.title),
      subtitle:
          task.details == null && task.dateTime == null && task.time == null
              ? null
              : _taskDetails(color),
      trailing: _togglePriorityBotton(ref, isHighPriorityFuture),
      leading: _toggleCompletedButton(isCompletedFuture, ref),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          final color = Theme.of(context).colorScheme;
          return Column(
            // itemExtent: 55,

            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    const SizedBox(width: 15,),

                    Icon(
                        Icons.edit,
                        color: themeController.selectedColor,
                      ),
                    const SizedBox(width: 10,),

                      Expanded(
                        child: FilledButton.tonal(
                          child: Text(
                            'Editar',
                            style: TextStyle(color: color.primary),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AddTask(
                                  task: task,
                                );
                              },
                            ).then((value) => Navigator.of(context).pop());
                          },
                        ),
                      ),

                    const SizedBox(width: 15,),
                    
                  ],
                ),
              ),


              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 15,),

                    Icon(
                      Icons.delete,
                      color: themeController.selectedColor,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: FilledButton.tonal(
                        child: Text(
                          'Eliminar',
                          style: TextStyle(color: color.primary),
                        ),
                        onPressed: () async {
                          await ref.read(taskProvider).deleteTask(task);
                          await ref.read(taskProvider).loadTask().then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 15,),

                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        },
      ),
      onLongPress: () => showDialog(
        context: context,
        builder: (context) {
          return _removeTaskDialog(context, ref);
        },
      ),
    );
  }

  AlertDialog _removeTaskDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('¿Borrar esta tarea?', textAlign: TextAlign.center),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () async {
              await ref.read(taskProvider).deleteTask(task).then((value) {
                ref.read(taskProvider).loadTask();
                Navigator.of(context).pop();
              });
            },
            child: const Text('Aceptar'))
      ],
    );
  }

  Checkbox _toggleCompletedButton(
      AsyncValue<bool> isCompletedFuture, WidgetRef ref) {
    return Checkbox(
      shape: const CircleBorder(),
      value: isCompletedFuture.when(
        data: (data) => data,
        error: (_, __) => throw UnimplementedError(),
        loading: () => false,
      ),
      onChanged: (value) async {
        await ref.read(taskProvider).toggleCompleted(task);
        ref.invalidate(isHighPriorityProvider(task));
        ref.invalidate(priorityTaskFProvider);
        ref.invalidate(isCompletedProvider(task));
        ref.invalidate(completedTaskFProvider);
      },
    );
  }

  IconButton _togglePriorityBotton(
      WidgetRef ref, AsyncValue<bool> isHighPriorityFuture) {
    return IconButton(
      onPressed: () async {
        await ref.read(taskProvider).togglePriority(task);
        ref.invalidate(isHighPriorityProvider(task));
        ref.invalidate(priorityTaskFProvider);
      },
      icon: isHighPriorityFuture.when(
        data: (data) {
          return data ? const Icon(Icons.star) : const Icon(Icons.star_border);
        },
        error: (_, __) => throw UnimplementedError(),
        loading: () => const Icon(Icons.star_border),
      ),
      iconSize: 28,
    );
  }

  Column _taskDetails(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (task.details != null) Text(task.details!),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (task.dateTime != null)
            OutlinedButton(
              onPressed: null,
              style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 5))),
              child: Text(
                formatDate(task.dateTime!, [d, '-', M, '-', yy]),
                style: TextStyle(color: color.primary),
              ),
            ),
          const SizedBox(
            width: 5,
          ),
          if (task.time != null)
            OutlinedButton(
              onPressed: null,
              style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              child: Text(
                task.time!,
                style: TextStyle(color: color.primary),
              ),
            ),
        ],
      ),
    ]);
  }
}
