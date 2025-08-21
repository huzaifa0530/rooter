import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/course_controller.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/services/notification_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfig {
  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
    
    final courseController = Get.put(CourseController());
    await courseController.fetchCourses();
    final userController = Get.put(UserController());    
    await userController.init();
    if (!kIsWeb) {
      await NotificationService.initializeFCM();
    }
  }
}
