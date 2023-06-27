import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

final priorityTaskFProvider = FutureProvider.autoDispose((ref) {
  final isarRepo = ref.watch(taskRepoProvider);
  return isarRepo.loadPriorityTask();
});

class PriorityView extends ConsumerStatefulWidget {
  static const String name = 'task-screen';

  const PriorityView({super.key});

  @override
  PriorityViewState createState() => PriorityViewState();
}

class PriorityViewState extends ConsumerState<PriorityView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() async {
    if (isLoading) return;
    isLoading = true;
    await ref.read(taskProvider).loadPriorityTask();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(priorityTaskFProvider);
    final textStyle = Theme.of(context).textTheme;

    return tasks.when(
      data: (data) {
        if (data.isEmpty) {
          return FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/feature.png',
                  height: 180,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'No tienes tareas destacadas',
                  style: GoogleFonts.kalam(fontSize: 24, fontWeight:FontWeight.w400 ),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Text(
                    'Marca las tareas importantes con una estrella para poder encontrarlas fácilmente aquí',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kalam(fontSize: 18),
                  ),
                )
              ],
            ),
          );
        }

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final task = data[index];

              return TaskDetails(
                task: task,
              );
            });
      },
      error: (error, stackTrace) => throw UnimplementedError(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
