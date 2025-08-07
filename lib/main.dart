import 'package:flutter/foundation.dart' show kIsWeb; // ADD THIS
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/CourseViewScreen.dart';
import 'package:rooster/HandbookDetailScreen.dart';
import 'package:rooster/LoginScreen.dart';
import 'package:rooster/NewsDetailScreen.dart';
import 'package:rooster/Controllers/login_controller.dart';
import 'package:rooster/translations.dart';
import 'package:rooster/SplashScreen.dart';
import 'package:rooster/HomeScreen.dart';
import 'package:rooster/Controllers/course_controller.dart';
import 'package:rooster/Controllers/NewsController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/Models/Handbook.dart';
import 'package:rooster/Models/NewsModel.dart';
Map<String, dynamic>? pendingNotificationArgs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setupFCM();
  }

  Get.put(CourseController());
  Get.put(UserController());

  runApp(const RoosterApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

void setupFCM() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  requestNotificationPermission();

  messaging.subscribeToTopic("news");
  messaging.subscribeToTopic("courses");
  messaging.subscribeToTopic("handbooks");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Foreground message: ${message.notification?.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    String? type = message.data['type'];
    String? id = message.data['id'];
    if (type != null && id != null) {
      int itemId = int.parse(id);
      handleNotificationNavigation(type, itemId);
    }
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void handleNotificationNavigation(String type, int itemId) async {
  final userController = Get.find<UserController>();

if (!userController.isLoggedIn.value) {
  pendingNotificationArgs = {'type': type, 'id': itemId};
  Get.to(() => LoginScreen());
  return;
}

  // User is logged in, navigate directly
  if (type == 'news') {
    final newsModel = await fetchNewsById(itemId);
    if (newsModel != null) {
      Get.to(() => NewsDetailScreen(news: newsModel));
    }
  } else if (type == 'courses') {
    final courseModel = await fetchCourseById(itemId);
    if (courseModel != null) {
      Get.to(() => CourseViewScreen(course: courseModel));
    }
  } else if (type == 'handbooks') {
    final handbook = await fetchHandbookById(itemId);
    if (handbook != null) {
      Get.to(() => HandbookDetailScreen(handbook: handbook));
    }
  }
}

void requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Notification permission granted');
  } else {
    print('❌ Notification permission denied');
  }
}

Future<NewsModel?> fetchNewsById(int id) async {
  final url = 'https://test.rubicstechnology.com/api/news/$id';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return NewsModel.fromJson(jsonData['data']);
    }
  } catch (e) {
    print('Error fetching news: $e');
  }
  return null;
}

Future<CourseModel?> fetchCourseById(int id) async {
  final url = 'https://test.rubicstechnology.com/api/courses/$id';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CourseModel.fromJson(jsonData['data']);
    }
  } catch (e) {
    print('Error fetching course: $e');
  }
  return null;
}

Future<Handbook?> fetchHandbookById(int id) async {
  final url = 'https://test.rubicstechnology.com/api/handbooks/$id';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Handbook.fromJson(jsonData['data']);
    }
  } catch (e) {
    print('Error fetching handbook: $e');
  }
  return null;
}

class RoosterApp extends StatelessWidget {
  const RoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ROOSTER',
      theme: ThemeData(
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
      ),
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
