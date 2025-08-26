import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/HomeController.dart';
import 'package:rooster/Models/CourseModel.dart';
import 'package:rooster/Screen/CourseListScreen.dart';
import 'package:rooster/Screen/CourseViewScreen.dart';
import 'package:rooster/Screen/HandbookBrowserScreen.dart';
import 'package:rooster/Screen/NewsDetailScreen.dart';
import 'package:rooster/Screen/NewsListScreen.dart';
import 'package:rooster/Widgets/custom_drawer.dart';
import 'package:rooster/config/api_config.dart';
import 'package:rooster/widgets/MainScaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeController = Get.put(HomeController());

    return MainScaffold(
      title: 'home',
      currentIndex: 0,
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            await homeController.fetchHomeData();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(6.0),
            children: [
              Text(
                'welcome_line'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'slogan'.tr,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // 📰 News section

              NewsSection(
                context,
                title: 'latest_news'.tr,
                icon: Icons.article_outlined,
                items: [],
                news: true,
                newsList: homeController.newsList,
              ),

              const SizedBox(height: 20),

              // 🍽️ Course section
              buildSection(
                context,
                homeController: homeController,
                title: 'latest_courses'.tr,
                icon: Icons.restaurant_menu_outlined,
                items: homeController.courseList,
                news: false,
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        tooltip: 'handbook'.tr,
        onPressed: () {
          Get.to(() =>  HandbookBrowserScreen());
        },
        label: Text('handbook'.tr),
        icon: const Icon(Icons.menu_book_outlined),
      ),
    );
  }

  Widget buildSection(
    BuildContext context, {
    required HomeController homeController,
    required String title,
    required IconData icon,
    required List<CourseModel> items,
    required bool news,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (news) {
                  Get.to(() => const NewsListScreen());
                } else {
                  Get.to(() => CourseListScreen());
                }
              },
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (news)
          const Text("News section placeholder...")
        else
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(icon, color: theme.colorScheme.primary),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Text('Tap for more details.'),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value:
                            double.parse(item.progress_percentage.toString()) /
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
                      '${item.progress_percentage}% completed',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => CourseViewScreen(course: item));
                },
              ),
            );
          }),
      ],
    );
  }

  // 🧩 News Section with horizontal scroll
  Widget NewsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> items,
    required bool news,
    required List newsList,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const NewsListScreen());
              },
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (news)
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final newsItem = newsList[index];
                String fullImageUrl = newsItem.imagePath.startsWith('http')
                    ? newsItem.imagePath
                    : '${ApiConfig.storageBaseUrl}/${newsItem.imagePath}';

                return GestureDetector(
                  onTap: () {
                    Get.to(() => NewsDetailScreen(news: newsItem));
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14)),
                          child: Image.network(
                            fullImageUrl,
                            height: 90,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${newsItem.publishedAt.day}/${newsItem.publishedAt.month}/${newsItem.publishedAt.year}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
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
    );
  }
}
