import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rooster/Controllers/HomeController.dart';
import 'package:rooster/CourseListScreen.dart';
import 'package:rooster/HandbookListScreen.dart';
import 'package:rooster/NewsListScreen.dart';

import 'package:rooster/Widgets/custom_drawer.dart';
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

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
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
                title: 'Latest News',
                icon: Icons.article_outlined,
                items: [],
                news: true,
                newsList: homeController.newsList,
              ),

              const SizedBox(height: 20),

              // 🍽️ Course section
              buildSection(
                context,
                title: 'latest_courses'.tr,
                icon: Icons.restaurant_menu_outlined,
                items: homeController.courseList.map((e) => e.title).toList(),
                news: false,
              ),
            ],
          ),
        );
      }),

      // 📘 Floating Handbook button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        tooltip: 'handbook'.tr,
        onPressed: () {
          Get.to(() => const HandbookListScreen());
        },
        label: Text('handbook'.tr),
        icon: const Icon(Icons.menu_book_outlined),
      ),
    );
  }

  // 🧩 Reusable Course or News Section
  Widget buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> items,
    required bool news,
  }) {
    final theme = Theme.of(context);
    final List<int> progress = [75, 45, 90];

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
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (news) {
                  Get.to(() => const NewsListScreen());
                } else {
                  Get.to(() => const CourseListScreen());
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
            final itemProgress = progress.length > index ? progress[index] : 0;
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
                  item,
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
                        value: itemProgress / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemProgress% completed',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => const CourseListScreen());
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
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                ImageProvider imageProvider = newsItem.imagePath.startsWith('http')
                    ? NetworkImage(newsItem.imagePath)
                    : AssetImage(newsItem.imagePath) as ImageProvider;

                return GestureDetector(
                  onTap: () {
                    Get.to(() => const NewsListScreen());
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
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(14)),
                          child: Image(
                            image: imageProvider,
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
