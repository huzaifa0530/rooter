// controllers/HandbookController.dart

import 'package:get/get.dart';
import 'package:rooster/Models/Handbook.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HandbookController extends GetxController {
  var handbooks = <Handbook>[].obs;
  var loading = false.obs;
  var isGrid = true.obs;

  final String baseUrl = 'https://test.rubicstechnology.com/api';

  @override
  void onInit() {
    fetchHandbooks();
    super.onInit();
  }

  void toggleLayout() => isGrid.value = !isGrid.value;

  Future<void> fetchHandbooks() async {
    try {
      loading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/handbooks'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        handbooks.value = (data['data'] as List)
            .map((item) => Handbook.fromJson(item))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to load handbooks");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<Handbook?> fetchHandbookDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/handbooks/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return Handbook.fromJson(data);
      } else {
        Get.snackbar("Error", "Failed to load handbook details");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
    return null;
  }

  Future<Handbook?> fetchHandbookById(int id) async {
    final url = 'https://test.rubicstechnology.com/api/handbooks/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Handbook.fromJson(jsonData['data']);
      }
    } catch (e) {
      print('Error fetching handbook: $e');
    }
    return null;
  }
}
