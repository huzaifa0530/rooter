import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/CourseViewScreen.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/controllers/course_controller.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  // 🧪 Sample course data
  List<CourseModel> _sampleCourses() {
    return [
      CourseModel(
        title: 'Mastering Fried Chicken Techniques',
        thumbnailPath: 'assets/images/chicken.jpg',
        instructor: 'Chef Adeel Khan',
        rating: 4.9,
        enrolled: 1025,
        duration: '2h 45m',
        sections: [
          SectionModel(title: 'Preparation Basics', lectures: [
            LectureModel(
                title: 'Selecting the Right Chicken Cuts',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
            LectureModel(
                title: 'Marination Techniques',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
          ]),
          SectionModel(title: 'Cooking Methods', lectures: [
            LectureModel(
                title: 'Deep Frying Like a Pro',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
            LectureModel(
                title: 'Oil Temperature Management',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
          ]),
        ],
        resources: ['assets/pdf/flutter_tutorial.pdf'],
      ),
      CourseModel(
        title: 'Hygiene and Food Safety Essentials',
        thumbnailPath: 'assets/images/Hygine.jpg',
        instructor: 'Manager Hina Sheikh',
        rating: 4.8,
        enrolled: 890,
        duration: '1h 30m',
        sections: [
          SectionModel(title: 'Personal Hygiene', lectures: [
            LectureModel(
                title: 'Hand Washing Techniques',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
            LectureModel(
                title: 'Uniform and Grooming Standards',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
          ]),
          SectionModel(title: 'Workplace Cleanliness', lectures: [
            LectureModel(
                title: 'Sanitizing Work Surfaces',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
            LectureModel(
                title: 'Waste Management Best Practices',
                videoUrl:
                    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
          ]),
        ],
        resources: ['assets/pdf/flutter_tutorial.pdf'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = _sampleCourses();

    final controller = Get.put(CourseController());

    return MainScaffold(
      title: 'latest_courses',
      currentIndex: 1,

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (_, i) {
          final course = courses[i];
          final isPopular = course.rating > 4.8;
          final progress = controller.getProgress(course.title);

          return InkWell(
            onTap: () => Get.to(() => CourseViewScreen(course: course)),
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
                    // 🖼 Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        course.thumbnailPath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 📚 Course Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷 Title + Badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  course.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // ⭐ Rating + 👥 Enrolled + ⏱ Duration
                          Wrap(
                            spacing: 10,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer,
                                      size: 14, color: Colors.grey[700]),
                                  const SizedBox(width: 2),
                                  Text(course.duration,
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // 📊 Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$progress% completed',
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
  }
}
