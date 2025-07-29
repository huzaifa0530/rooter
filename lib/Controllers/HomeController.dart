import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:rooster/Models/HomeScreenCourse.dart';
import 'package:rooster/Models/NewsModel.dart';
import 'dart:convert';

class HomeController extends GetxController {
  var newsList = <NewsModel>[].obs;
  var courseList = <HomeCourseModel>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://test.rubicstechnology.com/api';

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }
Future<void> fetchHomeData() async {
  try {
    isLoading.value = true;
    final response = await http.get(Uri.parse('$baseUrl/home'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    // print("Home API response: $data");

      final newsJson = data['news'];
      final coursesJson = data['courses'];

      // Defensive checks
      if (newsJson != null && newsJson is List) {
        newsList.value = newsJson.map((e) => NewsModel.fromJson(e)).toList();
      } else {
        newsList.value = [];
      }

      if (coursesJson != null && coursesJson is List) {
        courseList.value =
            coursesJson.map((e) => HomeCourseModel.fromJson(e)).toList();
      } else {
        courseList.value = [];
      }

      // print("News JSON: $newsJson");
      // print("Courses JSON: $coursesJson");
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
