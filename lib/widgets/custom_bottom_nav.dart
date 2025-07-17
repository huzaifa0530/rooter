import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/HomeScreen.dart';
import 'package:rooster/CourseListScreen.dart';
import 'package:rooster/NewsListScreen.dart';
import 'package:rooster/ProfileScreen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? currentIndex; // can be null when no tab should be active

  const CustomBottomNavBar({super.key, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'home'.tr),
      BottomNavigationBarItem(
          icon: const Icon(Icons.book), label: 'courses'.tr),
      BottomNavigationBarItem(
          icon: const Icon(Icons.article), label: 'news'.tr),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person), label: 'profile'.tr),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: (currentIndex != null &&
              currentIndex! >= 0 &&
              currentIndex! < items.length)
          ? currentIndex!
          : 0, // fallback to 0
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAll(() => const HomeScreen());
            break;
          case 1:
            Get.offAll(() => const CourseListScreen());
            break;
          case 2:
            Get.offAll(() => const NewsListScreen());
            break;
          case 3:
            Get.offAll(() => const ProfileScreen());
            break;
        }
      },

      items: items,
    );
  }
}
