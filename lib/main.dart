import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rooster/Screen/SplashScreen.dart';
import 'package:rooster/config/firebase_config.dart';
import 'package:rooster/config/theme.dart';
import 'package:rooster/config/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeApp();


  runApp(const RoosterApp());
}

class RoosterApp extends StatelessWidget {
  const RoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ROOSTER',
      theme: AppTheme.lightTheme,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
