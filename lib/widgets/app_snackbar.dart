import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error }

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color bgColor;
    Icon icon;

    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.green;
        icon = const Icon(Icons.check_circle, color: Colors.white);
        break;
      case SnackbarType.error:
        bgColor = Colors.red;
        icon = const Icon(Icons.error, color: Colors.white);
        break;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      borderRadius: 12,
      icon: icon,
      shouldIconPulse: true,
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutBack,
      barBlur: 12,
    );
  }
}
