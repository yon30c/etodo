import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../widgets.dart';

class CsNavbar extends ConsumerWidget {
  static int calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/task') {
      return 0;
    }
    if (location == '/priority') {
      return 1;
    }
    return 0;
  }

  void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/task');
        break;
      case 1:
        GoRouter.of(context).go('/priority');
        break;
      case 2:
        GoRouter.of(context).go('/completed');
    }
  }

  const CsNavbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final color = Theme.of(context).colorScheme;
    return BottomAppBar(
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.primary),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(_snackBar(context));
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () => showModalBottomSheet(
                useSafeArea: true,
                constraints: const BoxConstraints(maxHeight: 230),
                context: context,
                builder: (context) {
                  final color = Theme.of(context).colorScheme;
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      children: [
                        ListTile(
                            leading: Icon(
                              Icons.add_task,
                              color: color.primary,
                            ),
                            title: const Text('Agregar tarea'),
                            onTap: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddTask(
                                    task: ref.read(taskProvider).createTask(),
                                  );
                                },
                              );
                            }),
                        const Divider(),
                        ListTile(
                            leading: Icon(
                              Icons.done_all_rounded,
                              color: color.primary,
                            ),
                            title: const Text('Marcar todas como completadas'),
                            onTap: () {
                              ref.read(taskProvider).toggleAllCompleted();
                              Navigator.of(context).pop();
                            }),
                        const Divider(),
                        ListTile(
                          leading: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          title: const Text('Borrar las tareas completadas'),
                          onTap: () {
                            Navigator.of(context).pop();
                            ref.read(taskProvider).deleteAllCompleted();
                          },
                        ),
                      ]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  SnackBar _snackBar(context) {
    return SnackBar(
      content: const Text('Oops! este boton aun no esta activo'),
      action: SnackBarAction(
        label: 'Aceptar',
        onPressed: () {},
      ),
    );
  }
}
