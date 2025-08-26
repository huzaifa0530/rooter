import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:rooster/Controllers/NewsController.dart';
import 'package:rooster/config/api_config.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/VideoPlayerWidget.dart';
import 'package:rooster/widgets/tag_widget.dart';
import '../Models/NewsModel.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  NewsDetailScreen({super.key, required this.news});

  final NewsController controller = Get.put(NewsController());
  @override
  Widget build(BuildContext context) {
    controller.fetchNewsDetail(news.id);
    return MainScaffold(
      title: 'Rooster',
      currentIndex: null,
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.newsDetail.value == null) {
              return const Center(child: Text("Failed to load news"));
            }

            final updatedNews = controller.newsDetail.value!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    '${ApiConfig.storageBaseUrl}/${updatedNews.imagePath}',
                    fit: BoxFit.cover,
                    height: 220,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/images/no_image.jpg'),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  updatedNews.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  updatedNews.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.yMMMMd().format(updatedNews.publishedAt),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tags
                Wrap(
                  spacing: 8,
                  children: updatedNews.tags
                      .map((tag) =>
                          TagWidget(tag: tag, theme: Theme.of(context)))
                      .toList(),
                ),

                const SizedBox(height: 24),

                ...updatedNews.contentBlocks.map((block) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (block.type == ContentType.image) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '${ApiConfig.storageBaseUrl}/${block.mediaPath}',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset('assets/images/no_image.jpg'),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ] else if (block.type == ContentType.video) ...[
                          const Text(
                            '🎥 Video Preview',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 220, // pick a safe height
                              width: double.infinity,
                              child: VideoPlayerWidget(
                                videoUrl:
                                    '${ApiConfig.storageBaseUrl}/${block.mediaPath}',
                                autoPlay: true,
                                looping: true,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),
                          // Text(
                          //   'Video: ${block.mediaPath.split('/').last}',
                          //   style: const TextStyle(fontSize: 14, color: Colors.black54),
                          // ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          block.description,
                          style: const TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // Footer
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[100],
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Column(
                //     children: const [
                //       Text(
                //         'Did you enjoy this update?',
                //         style: TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.bold),
                //       ),
                //       SizedBox(height: 6),
                //       Text(
                //         'Share it with your friends or visit your nearest ROOSTER location today!',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(color: Colors.black54),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }


}
