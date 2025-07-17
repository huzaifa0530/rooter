import 'package:get/get.dart';
import '../Models/NewsModel.dart';

class NewsController extends GetxController {
  final newsList = <NewsModel>[
    NewsModel(
      title: 'Grand Opening Sale!',
      shortDescription: 'Up to 50% off for opening week!',
      fullDescription: 'Enjoy discounts on all menu items...',
      imagePath: 'assets/images/Branch.jpg',
      publishedAt: DateTime.now(),
    ),
    NewsModel(
      title: 'New Chicken Bucket Deal!',
      shortDescription: 'Get more for less.',
      fullDescription: 'Introducing our new chicken bucket...',
      imagePath: 'assets/images/chicken.jpg',
      publishedAt: DateTime.now(),
    ),
    NewsModel(
      title: 'Rooster Rewards Launched',
      shortDescription: 'Earn points on every order!',
      fullDescription: 'Sign up now and start earning...',
      imagePath: 'assets/images/summer.jpg',
      publishedAt: DateTime.now(),
    ),
  ].obs;
}
