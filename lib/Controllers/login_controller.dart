import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rooster/Controllers/user_controller.dart';
import 'package:rooster/config/api_config.dart';
import '../HomeScreen.dart';
import '../widgets/app_snackbar.dart';
import 'package:rooster/services/api_service.dart';

import 'package:rooster/services/notification_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.show(
        title: "Validation Error",
        message: "Email & Password cannot be empty",
        type: SnackbarType.error,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      isLoading.value = false;
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final user = data['user'];

        if (user['role'] != 'franchise' || user['status'] != 'active') {
          AppSnackbar.show(
            title: "Access Restricted",
            message: "You are restricted from accessing the app.",
            type: SnackbarType.error,
          );
          return;
        }

        await secureStorage.write(key: 'token', value: data['token']);
        await secureStorage.write(key: 'user', value: jsonEncode(user));

        final userController = Get.find<UserController>();
        userController.setUser(user['name'], user['email']);

        AppSnackbar.show(
          title: "Login Success",
          message: data['message'] ?? 'Welcome!',
          type: SnackbarType.success,
        );

        print(
            "📦 Pending notification args: ${NotificationService.pendingNotificationArgs}");
        final args = NotificationService.pendingNotificationArgs;

        if (args != null &&
            args.containsKey('type') &&
            args.containsKey('id')) {
          print(
              "🚀 Redirecting to detail with type: ${args['type']}, id: ${args['id']}");
          NotificationService.pendingNotificationArgs = null;
          Future.delayed(const Duration(milliseconds: 1200), () {
            ApiService.handleNotificationNavigation(args['type'], args['id']);
          });
        } else {
          print("🏠 Redirecting to HomeScreen");
          Future.delayed(const Duration(milliseconds: 1200), () {
            Get.offAll(() => const HomeScreen());
          });
        }
      } else if (response.statusCode == 422) {
        AppSnackbar.show(
          title: "Invalid Credentials",
          message: data['message'] ?? "Email or password is incorrect",
          type: SnackbarType.error,
        );
      } else {
        // Other errors
        AppSnackbar.show(
          title: "Login Failed",
          message: data['message'] ?? "Something went wrong",
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.show(
        title: "Network Error",
        message: "Could not connect to the server. Please try again.",
        type: SnackbarType.error,
      );
    }
  }
}
