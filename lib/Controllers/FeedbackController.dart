import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/Models/FeedbackModel.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;

Future<bool> submitFeedback({
  required int userId,
  required String name,
  required String email,
  required String msg,
}) async {
  try {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse("https://test.rubicstechnology.com/api/feedback"),
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
      Get.snackbar(
          "Success", data["message"] ?? "Feedback submitted successfully!");
      debugPrint("✅ Feedback submitted: ${response.body}");
      return true; // 🔹 indicate success
    } else {
      debugPrint("❌ API Error: ${response.statusCode} ${response.body}");
      Get.snackbar("Error", data["message"] ?? "Failed to submit feedback.");
      return false;
    }
  } catch (e, stack) {
    debugPrint("❌ Exception in submitFeedback: $e");
    debugPrintStack(stackTrace: stack);
    Get.snackbar("Error", "An unexpected error occurred.");
    return false;
  } finally {
    isLoading.value = false;
  }
}
}