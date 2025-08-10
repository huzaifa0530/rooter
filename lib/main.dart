import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:rooster/Controllers/course_controller.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/SplashScreen.dart';
import 'package:rooster/config/firebase_config.dart';
import 'package:rooster/config/theme.dart';
import 'package:rooster/config/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeApp();
  Get.put(CourseController());
  Get.put(UserController());

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
