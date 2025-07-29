import 'package:flutter/material.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/PdfViewerScreen.dart';

import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:rooster/controllers/lecture_controller.dart';

class CourseViewScreen extends StatefulWidget {
  final CourseModel course;
  const CourseViewScreen({super.key, required this.course});

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LectureController lectureController = Get.put(LectureController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<LectureController>(); // Optional cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ROOSTER'),
        backgroundColor: theme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: Colors.white),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          tabs: [
            Tab(text: 'overview'.tr),
            Tab(text: 'content'.tr),
            Tab(text: 'resources'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(course, theme),
          _buildContentTab(course, theme),
          _buildResourcesTab(course.resources, theme),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(CourseModel course, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(course.thumbnailPath,
                height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(course.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Instructor: ${course.instructor}',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              // const Icon(Icons.star, color: Colors.amber, size: 18),
              // const SizedBox(width: 4),
              // Text('${course.rating}', style: theme.textTheme.bodyMedium),
              // const SizedBox(width: 16),
              // const Icon(Icons.group, color: Colors.grey, size: 18),
              // const SizedBox(width: 4),
              // Text('${course.enrolled} ${'students'.tr}',
              //     style: theme.textTheme.bodyMedium),
              // const SizedBox(width: 16),
              // const Icon(Icons.timer, color: Colors.grey, size: 18),
              // const SizedBox(width: 4),
              Text(course.duration, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'This course is designed to provide a comprehensive understanding of ${course.title}. You’ll explore practical examples, watch videos, and get access to high-quality learning materials.',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab(CourseModel course, ThemeData theme) {
    return Obx(() => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (lectureController.isLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                ),
              )
            else if (lectureController.currentLecture != null &&
                lectureController.chewieController != null &&
                lectureController.videoController != null &&
                lectureController.videoController!.value.isInitialized)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio:
                        lectureController.videoController!.value.aspectRatio,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Chewie(
                          controller: lectureController.chewieController!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lectureController.currentLecture!.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            else
              const Center(
                child: Text("Tap a lecture to begin watching.",
                    style: TextStyle(fontSize: 16)),
              ),

            // Lecture List
            ...course.sections.map((section) => ExpansionTile(
                  title: Text(section.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  children: section.lectures.map((lecture) {
                    return ListTile(
                      title: Text(lecture.title),
                      leading: Icon(
                        lecture.isViewed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: lecture.isViewed ? Colors.green : Colors.grey,
                      ),
                      trailing: const Icon(Icons.play_circle_fill,
                          color: Colors.deepPurple),
                      onTap: () => lectureController.playLecture(lecture),
                    );
                  }).toList(),
                )),
          ],
        ));
  }

  Widget _buildResourcesTab(List<String> resources, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) => ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
        title: Text('Download Resource ${i + 1}'),
        subtitle:
            Text(resources[i], maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.download),
        onTap: () async {
          Get.to(() => PdfViewerScreen(path: resources[i]));
        },
      ),
    );
  }
}
