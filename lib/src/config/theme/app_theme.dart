import 'package:etodo/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<Color> colors = [
  Colors.blue,
  Colors.teal,
  Colors.redAccent,
  Colors.deepOrangeAccent,
  Colors.indigo,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0, 'Selected color must be grater than 0'),
        assert(selectedColor <= colors.length - 1,
            'Selected color must be less or equal than ${colors.length - 1}');

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: themeController.selectedColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
            bodyMedium: GoogleFonts.oswald(),
            titleLarge: GoogleFonts.oswald(),
            titleMedium: GoogleFonts.oswald(),
            bodyLarge: GoogleFonts.oswald(),
            bodySmall: GoogleFonts.oswald()),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
      );

  ThemeData getDarkTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: themeController.selectedColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
            bodyMedium: GoogleFonts.oswald(),
            titleLarge: GoogleFonts.oswald(),
            titleMedium: GoogleFonts.oswald(),
            bodyLarge: GoogleFonts.oswald(),
            bodySmall: GoogleFonts.oswald()),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
      );
}
