import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/translations.dart';
import 'package:rooster/SplashScreen.dart';

void main() {
  runApp(const RoosterApp());
}

class RoosterApp extends StatelessWidget {
  const RoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ROOSTER',
      theme: ThemeData(
          fontFamily: 'Poppins',
        primaryColor: const Color(0xFFF60705), // Red (Brand Color)
        scaffoldBackgroundColor: Colors.white, // Changed from yellow to white
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFF60705), // Red
          onPrimary: Colors.white,
          secondary: Color(0xFFFF6600), // Orange
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white, // Changed from yellow to white
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
      ),
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
