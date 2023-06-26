import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/notifications/notifications.dart';
import '../../providers/providers.dart';
import '../../views/views.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;

  static const String name = 'Home-screen';

  const HomeScreen({super.key, required this.child});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    LocalNotifications.requestPermission();
    tabController = TabController(
        initialIndex: 1,
        length: 3,
        vsync: this,
        animationDuration: const Duration(milliseconds: 200));
    tabController!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  List<Widget> children = const [PriorityView(), TasksView(), CompletedView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        bottom: _customTabBar(context),
      ),
      body: TabBarView(controller: tabController, children: children),
      bottomNavigationBar: const CsNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: const _CsFloatingB(),
    );
  }

  TabBar _customTabBar(BuildContext context) {
    return TabBar(
        labelPadding: const EdgeInsets.only(),
        splashFactory: NoSplash.splashFactory,
        controller: tabController,
        enableFeedback: true,
        dragStartBehavior: DragStartBehavior.start,
        physics: const BouncingScrollPhysics(),
        // onTap: (value) => onItemTapped(value, context),
        tabs: const [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.star,
                  size: 20,
                ),
                Text('Destacadas')
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, size: 20),
                SizedBox(
                  width: 5,
                ),
                Text('Mis tareas')
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.done_all,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text('Completadas')
              ],
            ),
          )
        ]);
  }
}

class _CsFloatingB extends ConsumerWidget {
  const _CsFloatingB();

  @override
  Widget build(BuildContext context, ref) {
    final color = Theme.of(context).colorScheme;
    return FloatingActionButton(
        backgroundColor: color.primaryContainer,
        onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AddTask(
                  task: ref.read(taskProvider).createTask(),
                );
              },
            ),
        child: const Icon(Icons.add));
  }
}
