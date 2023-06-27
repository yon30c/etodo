import 'package:etodo/src/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';

import 'config/config.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) => 
       MaterialApp.router(
        title: 'ToDo List',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme(selectedColor: 1).getTheme(),
        darkTheme: AppTheme(selectedColor: 1).getDarkTheme(),
        themeMode: themeController.themeMode,
      ),
    );
  }
}
