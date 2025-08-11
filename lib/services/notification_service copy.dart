import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/services/api_service.dart';

class NotificationService {
  static Map<String, dynamic>? pendingNotificationArgs;

  static Future<void> initializeFCM() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      pendingNotificationArgs = {
        'type': initialMessage.data['type'],
        'id': int.tryParse(initialMessage.data['id'] ?? '') ?? 0,
      };
    }

    await requestPermission();
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    subscribeToTopics();
    handleMessageEvents();
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling background message: ${message.messageId}');
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('⚠️ Provisional notification permission granted');
    } else {
      print('❌ Notification permission denied');
    }
  }

  static void subscribeToTopics() {
    FirebaseMessaging.instance.subscribeToTopic("news");
    FirebaseMessaging.instance.subscribeToTopic("courses");
    FirebaseMessaging.instance.subscribeToTopic("handbooks");
  }

  static void handleMessageEvents() {
    FirebaseMessaging.onMessage.listen((message) {
      print('🔔 Foreground message: ${message.notification?.title}');
    });

  
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      String? type = message.data['type'];
      String? id = message.data['id'];
      if (type != null && id != null) {
        int itemId = int.parse(id);
        final userController = Get.find<UserController>();

        if (userController.isLoggedIn.value) {
          ApiService.handleNotificationNavigation(type, itemId);
        } else {
          pendingNotificationArgs = {'type': type, 'id': itemId};
        }
      }
    });
  }
}
