import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseController extends GetxController {
  var courses = <CourseModel>[].obs;
  var isLoading = false.obs; 
  var selectedCourse = Rxn<CourseModel>();

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
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

  Future<void> fetchCourses() async {
    isLoading.value = true;
    try {
      final userId = await _getLoggedInUserId();
      if (userId == null) {
        print("⚠ No logged-in user ID found.");
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://handbuch-rfc.com/api/courses/list/$userId'),
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        List data = jsonBody; 
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
            final userId = await _getLoggedInUserId();
      if (userId == null) {
        print("⚠ No logged-in user ID found.");
        isLoading.value = false;
        return;
      }
      final response = await http.get(
          Uri.parse('https://handbuch-rfc.com/api/courses/$courseId/$userId'));

      // print('Course Detail Status Code: ${response.statusCode}');
      // print('Course Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded != null && decoded is Map<String, dynamic>) {
          final course = CourseModel.fromJson(decoded);
          selectedCourse.value = course;
          // print('Course Loaded: ${course.title}');
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


  Future<CourseModel?> fetchCourseById(int id) async {
    final url = 'https://handbuch-rfc.com/api/courses/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CourseModel.fromJson(jsonData['data']);
      }
    } catch (e) {
      print('Error fetching course: $e');
    }
    return null;
  }
}
