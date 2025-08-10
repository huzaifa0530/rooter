// user_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // ✅ for debugPrint
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final isLoggedIn = false.obs;

  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<void> init() async {
    try {
      final token = await storage.read(key: 'token');
      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;

        final userJson = await storage.read(key: 'user');
        if (userJson != null && userJson.isNotEmpty) {
          try {
            final Map<String, dynamic> userMap = json.decode(userJson);
            name.value = userMap['name']?.toString() ?? '';
            email.value = userMap['email']?.toString() ?? '';
          } catch (e) {
            debugPrint('UserController.init: failed to parse user json: $e');
          }
        }
      } else {
        isLoggedIn.value = false;
      }
      debugPrint(
        'UserController.init -> isLoggedIn=${isLoggedIn.value}, token=$token',
      );
    } catch (e) {
      debugPrint('UserController.init error: $e');
      isLoggedIn.value = false;
    }
  }

  void setUser(String userName, String userEmail) {
    name.value = userName;
    email.value = userEmail;
    isLoggedIn.value = true;
  }

  Future<void> logout({bool clearStorage = true}) async {
    name.value = '';
    email.value = '';
    isLoggedIn.value = false;
    if (clearStorage) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'user');
    }
  }
}
