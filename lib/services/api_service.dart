import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:rooster/CourseViewScreen.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/Models/NewsModel.dart';
import 'package:rooster/NewsDetailScreen.dart';
import 'package:rooster/config/api_config.dart';

import 'package:rooster/models/handbook.dart';

class ApiService {
  static const baseUrl = 'https://handbuch-rfc.com/api';

  static Future<NewsModel?> fetchNewsById(int id) async {
    // return _fetchData<NewsModel>('$baseUrl/news/$id', (json) => NewsModel.fromJson(json));

    return _fetchData<NewsModel>(
        '${ApiConfig.newsById(id)}', (json) => NewsModel.fromJson(json));
  }

  static Future<CourseModel?> fetchCourseById(int id) async {
    return _fetchData<CourseModel>(
        '$baseUrl/courses/$id', (json) => CourseModel.fromJson(json));
  }

  static Future<Handbook?> fetchHandbookById(int id) async {
    return _fetchData<Handbook>(
        '$baseUrl/handbooks/$id', (json) => Handbook.fromJson(json));
  }

  static Future<T?> _fetchData<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData['data']);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

  static Future<void> handleNotificationNavigation(
      String type, int itemId) async {
    if (type == 'news') {
      final news = await fetchNewsById(itemId);
      if (news != null) Get.to(() => NewsDetailScreen(news: news));
    } else if (type == 'courses') {
      final course = await fetchCourseById(itemId);
      if (course != null) Get.to(() => CourseViewScreen(course: course));
    }
    // else if (type == 'handbooks') {
    //   final handbook = await fetchHandbookById(itemId);
    //   if (handbook != null) Get.to(() => HandbookDetailScreen(handbook: handbook));
    // }
  }
}
