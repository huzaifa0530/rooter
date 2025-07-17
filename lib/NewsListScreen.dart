import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rooster/Models/NewsModel.dart';
import 'package:rooster/NewsDetailScreen.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<NewsModel> newsList = [
      NewsModel(
        title: 'New Branch Opening 🎉',
        shortDescription: 'ROOSTER is opening a new branch in Berlin!',
        fullDescription:
            'Our newest ROOSTER branch offers fresh, crispy chicken and a modern atmosphere. Visit us in Berlin Mitte starting August 15.',
        imagePath: 'assets/images/Branch.jpg',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NewsModel(
        title: 'Summer Menu Offers 🌞',
        shortDescription: 'Enjoy special summer menu deals!',
        fullDescription:
            'ROOSTER presents exclusive summer menus with refreshing side dishes and new chicken varieties. Available for a limited time only.',
        imagePath: 'assets/images/summer.jpg',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      NewsModel(
        title: 'ROOSTER App Update 📱',
        shortDescription: 'Improved features in the app.',
        fullDescription:
            'Our latest app version now offers faster ordering, real-time deals, and an improved user interface.',
        imagePath: 'assets/images/App_Update.png',
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    return MainScaffold(
      title: 'latest_news'.tr,
      currentIndex: 2,
  
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'whats_cooking'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'stay_updated'.tr,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  final isRecent =
                      DateTime.now().difference(news.publishedAt).inDays <= 3;

                  return Card(
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Get.to(() => NewsDetailScreen(news: news)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.asset(
                              news.imagePath,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        news.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (isRecent)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'new'.tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  news.shortDescription,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMMMMd()
                                          .format(news.publishedAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: theme.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => Get.to(
                                          () => NewsDetailScreen(news: news)),
                                      child: Text('read_more'.tr),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
