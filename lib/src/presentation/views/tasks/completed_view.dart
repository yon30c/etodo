import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

final completedTaskFProvider = FutureProvider.autoDispose((ref) {
  final isarRepo = ref.watch(taskRepoProvider);
  return isarRepo.loadCompletedTask();
});


class CompletedView extends ConsumerStatefulWidget {
  static const String name = 'task-screen';

  const CompletedView({super.key});

  @override
  CompletedViewState createState() => CompletedViewState();
}

class CompletedViewState extends ConsumerState<CompletedView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() async {
    if (isLoading) return;
    isLoading = true;
    await ref.read(taskProvider).loadCompletedTask();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider).completTasks;
    final textStyle = Theme.of(context).textTheme;

    // return 
    // tasks.when(
    //   data: (data) {
        
        if (tasks.isEmpty) {
          return FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/comp.png',
                  height: 180,
                ),
                const SizedBox(
                  height: 10,
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: Text(
                    'No tienes tareas completadas',
                    style: textStyle.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return CompletedTask(
                task: task,
              );
            });
      // },
      // error: (error, stackTrace) => throw UnimplementedError(),
      // loading: () => const Center(
      //   child: CircularProgressIndicator(),
      // ),
    // );
  }
}
