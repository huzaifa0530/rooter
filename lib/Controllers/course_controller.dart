import 'package:get/get.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseController extends GetxController {
  var courses = <CourseModel>[].obs;
  var isLoading = false.obs; // Declare ONLY ONCE
  var selectedCourse = Rxn<CourseModel>();

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
  }

  Future<void> fetchCourses() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://test.rubicstechnology.com/api/courses'),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List data = jsonBody; // assuming API returns a list directly
        courses.value = data.map((e) => CourseModel.fromJson(e)).toList();
      } else {
        print('Failed to load courses. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCourseDetail(int courseId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('https://test.rubicstechnology.com/api/courses/$courseId'));

      print('Course Detail Status Code: ${response.statusCode}');
      print('Course Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded != null && decoded is Map<String, dynamic>) {
          final course = CourseModel.fromJson(decoded);
          selectedCourse.value = course;
          print('Course Loaded: ${course.title}');
        } else {
          print('Unexpected response format (not a Map): $decoded');
          Get.snackbar('Error', 'Unexpected response from server');
        }
      } else {
        print('Failed to load course detail. Status: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load course detail');
      }
    } catch (e, stackTrace) {
      print('Error fetching course detail: $e');
      print('Stack Trace: $stackTrace');
      Get.snackbar('Error', 'Course detail fetch failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int getProgress(String courseTitle) {
    return 20; // fake progress for now
  }
}
