import 'package:get/get.dart';

class CourseController extends GetxController {
  // Key: course title, Value: progress (0–100)
  final RxMap<String, int> courseProgress = <String, int>{}.obs;

  void setProgress(String courseTitle, int value) {
    courseProgress[courseTitle] = value;
  }

  int getProgress(String courseTitle) {
    return courseProgress[courseTitle] ?? 0;
  }

  @override
  void onInit() {
    super.onInit();

    // 🔢 Mock progress values
    courseProgress['Mastering Fried Chicken Techniques'] = 80;
    courseProgress['Hygiene and Food Safety Essentials'] = 45;
  }
}
