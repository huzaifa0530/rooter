import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/Models/FeedbackModel.dart';
import 'package:rooster/config/api_config.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;
  Future<FeedbackModel?> submitFeedback({
    required int userId,
    required String name,
    required String email,
    required String msg,
  }) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(ApiConfig.feedback),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "name": name,
          "email": email,
          "msg": msg,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["feedback"] != null) {
          final feedback = FeedbackModel.fromJson(data["feedback"]);
          Get.snackbar("Success", data["message"] ?? "Feedback submitted!");
          // debugPrint("✅ Feedback submitted: ${feedback.msg}");
          return feedback;
        } else {
          Get.snackbar("Success", data["message"] ?? "Feedback submitted!");
          // debugPrint(
          //     "✅ Feedback submitted but no feedback object in response.");
          return null;
        }
      }
    } catch (e, stack) {
      debugPrint("❌ Exception in submitFeedback: $e");
      debugPrintStack(stackTrace: stack);
      Get.snackbar("Error", "An unexpected error occurred.");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
