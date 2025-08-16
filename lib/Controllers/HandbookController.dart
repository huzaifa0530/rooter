import 'package:get/get.dart';
import 'package:rooster/Models/Handbook.dart';
import 'package:rooster/services/handbook_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HandbookController extends GetxController {
  var path = <Map<String, dynamic>>[].obs; // breadcrumb path
  var isLoading = false.obs;
  var subCategories = <Map<String, dynamic>>[].obs;
  var handbooks = <Handbook>[].obs;
  var errorMessage = "".obs;
  final String baseUrl = 'https://handbuch-rfc.com/api';

  @override
  void onInit() {
    super.onInit();
    loadRoot();
  }

  void loadRoot() async {
    path.clear();
    await _fetchData(isRoot: true);
  }

  void loadCategory(int id, String name) async {
    path.add({"id": id, "name": name});
    await _fetchData(categoryId: id);
  }

  void goBack() async {
    if (path.isNotEmpty) {
      path.removeLast();
    }
    if (path.isEmpty) {
      await _fetchData(isRoot: true);
    } else {
      await _fetchData(categoryId: path.last["id"]);
    }
  }

  void jumpToBreadcrumb(int index) async {
    path.value = path.sublist(0, index + 1);
    await _fetchData(categoryId: path.last["id"]);
  }

  Future<void> _fetchData({bool isRoot = false, int? categoryId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      Map<String, dynamic> data = isRoot
          ? await HandbookService.fetchRoot()
          : await HandbookService.fetchCategory(categoryId!);

      subCategories.value =
          List<Map<String, dynamic>>.from(data["subCategories"]);
      handbooks.value = List<Map<String, dynamic>>.from(data["handbooks"])
          .map((e) => Handbook.fromJson(e))
          .toList();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
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
}
