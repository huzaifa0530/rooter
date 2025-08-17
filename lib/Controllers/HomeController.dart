import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/Models/NewsModel.dart';
import 'package:rooster/config/api_config.dart';

class HomeController extends GetxController {
  var newsList = <NewsModel>[].obs;
  var courseList = <CourseModel>[].obs;
  var isLoading = false.obs;

  // final String baseUrl = 'https://handbuch-rfc.com/api';

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  final storage = const FlutterSecureStorage();

  Future<String?> _getLoggedInUserId() async {
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return userMap['id']?.toString();
    }
    return null;
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      final userId = await _getLoggedInUserId();
      if (userId == null) {
        print("⚠ No logged-in user ID found.");
        isLoading.value = false;
        return;
      }
      // final response = await http.get(Uri.parse('$baseUrl/home/$userId'));
      final response = await http
          .get(Uri.parse(ApiConfig.homeData(int.parse(userId))));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Home API response: $data");

        final newsJson = data['news'];
        final coursesJson = data['courses'];

        if (newsJson != null && newsJson is List) {
          newsList.value = newsJson.map((e) => NewsModel.fromJson(e)).toList();
        } else {
          newsList.value = [];
        }

        if (coursesJson != null && coursesJson is List) {
          courseList.value =
              coursesJson.map((e) => CourseModel.fromJson(e)).toList();
        } else {
          courseList.value = [];
        }
      } else {
        Get.snackbar("Error", "Failed to load home data");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  
}
