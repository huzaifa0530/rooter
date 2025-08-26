import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Screen/HomeScreen.dart';
import 'package:rooster/Screen/CourseListScreen.dart';
import 'package:rooster/Screen/NewsListScreen.dart';
import 'package:rooster/Screen/ProfileScreen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? currentIndex; 

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
  currentIndex: currentIndex ?? 0,
  selectedItemColor: currentIndex == null ? Colors.grey : theme.primaryColor,
  unselectedItemColor: Colors.grey,

  onTap: (index) {
    // Always navigate regardless of currentIndex
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
