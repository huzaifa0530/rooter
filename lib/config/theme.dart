import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: const Color(0xFFF60705),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFF60705),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF6600),
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Color(0xFFF2F2F2),
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF60705),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFF60705),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
