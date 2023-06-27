import 'package:etodo/main.dart';
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
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                      const SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.delete,
                    color: themeController.selectedColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FilledButton.tonal(
                      style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 130))),
                      child: const Text('Eliminar'),
                      onPressed: () async {
                        await ref
                            .read(taskProvider)
                            .deleteTask(widget.task)
                            .then((value) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ]),
              ),

              const SizedBox(height: 7,),
              SizedBox(
                
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                     Icon(Icons.cancel, color: themeController.selectedColor ,),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FilledButton.tonal(
                       
                        child: const Text('Marcas como no completada'),
                        onPressed: () async {
                          await ref
                              .read(taskProvider)
                              .toggleCompleted(widget.task)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }
}
