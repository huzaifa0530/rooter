import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/CourseViewScreen.dart';
import 'package:rooster/Controllers/course_controller.dart';
import 'package:rooster/widgets/MainScaffold.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<CourseController>(); 

    return MainScaffold(
      title: 'latest_courses',
      currentIndex: 1,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final courses = controller.courses;

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchCourses();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (_, i) {
              final course = courses[i];
              return InkWell(
                onTap: () async {
                  final courseController = Get.find<CourseController>();
                  await courseController.fetchCourseDetail(course.id);

                  if (courseController.selectedCourse.value != null) {
                    Get.to(() => CourseViewScreen(
                        course: courseController.selectedCourse.value!));
                  }
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://handbuch-rfc.com/storage/app/public/${course.thumbnailPath}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(course.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              // const SizedBox(height: 6),
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     Icon(Icons.timer,
                              //         size: 14, color: Colors.grey[700]),
                              //     const SizedBox(width: 2),
                              //     Text(course.duration,
                              //         style: const TextStyle(fontSize: 13)),
                              //   ],
                              // ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: double.parse(course.progress_percentage
                                          .toString()) /
                                      100,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${course.progress_percentage}% completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
