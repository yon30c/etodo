import 'package:etodo/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../main.dart';
import '../../providers/providers.dart';

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
            _markAllCompleted(context, ref),
            _deleteAllCompleted(context, ref),
            _moreVert(context, ref)
          ],
        ),
      ),
    );
  }

  IconButton _moreVert(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.more_horiz),
      onPressed: () => showModalBottomSheet(
        useSafeArea: true,
        // constraints: const BoxConstraints(maxHeight: 230),
        context: context,
        builder: (context) {
          final textStyle = Theme.of(context).textTheme;
          return SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Apariencia',
                      style: textStyle.titleMedium,
                    ),
                  ),
                  SegmentedButton(
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.comfortable,
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 20))),
                      onSelectionChanged: (value) {
                        themeController.updateThemeMode(value.first);
                      },
                      segments: const [
                        ButtonSegment(
                            enabled: true,
                            value: ThemeMode.light,
                            label: Text('Claro')),
                        ButtonSegment(
                            enabled: true,
                            value: ThemeMode.system,
                            label: Text('Sistema')),
                        ButtonSegment(
                            enabled: true,
                            value: ThemeMode.dark,
                            label: Text('Oscuro')),
                      ],
                      selected: {
                        themeController.themeMode
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Colores',
                      style: textStyle.titleMedium,
                    ),
                  ),
                  SegmentedButton(
                      showSelectedIcon: false,
                      onSelectionChanged: (value) =>
                          {themeController.updateSelectedColor(value.first)},
                      segments: colors
                          .map((e) => ButtonSegment(
                              value: e,
                              label: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: e,
                                ),
                                width: 30,
                                height: 30,
                              )))
                          .toList(),
                      selected: {themeController.selectedColor}),
                  const SizedBox(
                    height: 20,
                  )
                ]),
          );
        },
      ),
    );
  }

  IconButton _deleteAllCompleted(BuildContext context, ref) {
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                final textStyle = Theme.of(context).textTheme;
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Eliminar tareas completadas',
                          style: textStyle.titleMedium,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: FilledButton(
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 5))),
                            onPressed: () {
                              ref.read(taskProvider).deleteAllCompleted();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar')),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: FilledButton.tonal(
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 5))),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar')),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              });
        },
        icon: const Icon(
          Icons.delete_forever_rounded,
        ));
  }

  IconButton _markAllCompleted(BuildContext context, ref) {
    return IconButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              final textStyle = Theme.of(context).textTheme;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Marcar todo como completado',
                        style: textStyle.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: FilledButton(
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5))),
                          onPressed: () {
                            ref.read(taskProvider).toggleAllCompleted();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar')),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: FilledButton.tonal(
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 5))),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar')),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            }),
        icon: const Icon(Icons.done_all_rounded));
  }
}
