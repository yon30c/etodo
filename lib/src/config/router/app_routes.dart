//! Recuerda importar el paquete de go_router
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';
import '../../presentation/views/views.dart';


final router = GoRouter(initialLocation: '/', routes: [
  ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/', 
          redirect: (context, state) => '/task',
        ),

        GoRoute(
          path: '/task',
          name: TasksView.name,
          builder: (context, state) => const TasksView(),
          // routes: [
          // //?Sub-rutas del home, se usa para el deeplinking
          // ]
        ),
        GoRoute(
          path: '/priority',
          builder: (context, state) => const PriorityView(),
        ),
        GoRoute(
          path: '/completed',
          builder: (context, state) => const CompletedView(),
        ),
        
      ])
]);
