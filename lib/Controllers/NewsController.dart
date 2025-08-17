import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rooster/config/api_config.dart';
import 'dart:convert';

import '../Models/NewsModel.dart';

class NewsController extends GetxController {
  var newsList = <NewsModel>[].obs;
  // final String baseUrl = 'https://handbuch-rfc.com/api';

  @override
  void onInit() {
    super.onInit();
    fetchNewsList();
  }

  Future<void> fetchNewsList() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.newsList));
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

  var isLoading = false.obs;
  var newsDetail = Rxn<NewsModel>();
  Future<void> fetchNewsDetail(int id) async {
    final String url = ApiConfig.newsById(id);

    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        newsDetail.value = NewsModel.fromJson(jsonData['data']);
      } else {
        Get.snackbar(
            "Error", "Failed to load news detail: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
