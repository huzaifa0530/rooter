import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/NewsModel.dart';

class NewsController extends GetxController {
  var newsList = <NewsModel>[].obs;
  final String baseUrl = 'https://test.rubicstechnology.com/api'; // Replace with your Laravel backend

  @override
  void onInit() {
    super.onInit();
    fetchNewsList();
  }
Future<void> fetchNewsList() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/news'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true) {
        newsList.value = List<NewsModel>.from(
          data['data'].map((n) => NewsModel.fromJson(n)),
        );
      }
    } else {
      Get.snackbar('Error', 'Failed to load news list');
    }
  } catch (e) {
    print(e);
    Get.snackbar('Error', 'Something went wrong while fetching news');
  }
}



}
