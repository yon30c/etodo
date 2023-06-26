import 'package:flutter/material.dart';
const List<Color> colors = [
  Colors.black,
  Colors.blue,
  Colors.teal,
  Colors.greenAccent,
  Colors.redAccent,
  Colors.purple,
  Colors.deepOrangeAccent,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0, 'Selected color must be grater than 0'),
        assert(selectedColor <= colors.length -1  , 'Selected color must be less or equal than ${colors.length - 1}');

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colors[selectedColor],
    appBarTheme: const AppBarTheme(
      centerTitle: true
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
  );

  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: colors[selectedColor],
    appBarTheme: const AppBarTheme(
      centerTitle: true
    ),
   
    floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
  );
}