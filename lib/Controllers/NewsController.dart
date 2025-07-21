import 'package:get/get.dart';
import '../Models/NewsModel.dart';

class NewsController extends GetxController {
  final newsList = <NewsModel>[
    NewsModel(
      title: '🎉 Grand Opening: Rooster Arrives in Downtown!',
      shortDescription: 'Enjoy 50% off + free drinks in our brand-new city branch!',
      description:
          'We’re thrilled to open our doors in the heart of the city with mouth-watering offers, great ambiance, and finger-licking chicken deals.',
      imagePath: 'assets/images/Branch.jpg',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      contentBlocks: [
        NewsContent(type: ContentType.image, data: 'assets/images/Branch.jpg'),
        NewsContent(
          type: ContentType.text,
          data:
              'After months of preparation, our newest ROOSTER branch has finally opened! Located on Main Street near Central Plaza, this new outlet offers a modern interior, cozy seating for families, and a rooftop space for special events.',
        ),
        NewsContent(type: ContentType.image, data: 'assets/images/chicken.jpg'),
        NewsContent(
          type: ContentType.text,
          data:
              'To celebrate, we’re offering **50% off** on our legendary Spicy Bucket Combo and free soft drinks for the first 500 customers. Don’t miss out!',
        ),
        NewsContent(type: ContentType.video, data: 'assets/videos/branch_teaser.mp4'),
        NewsContent(
          type: ContentType.text,
          data:
              'Check out this teaser from our opening day — see the crowd, taste the excitement, and feel the flavor. 🔥🍗',
        ),
      ],
    ),
    NewsModel(
      title: '🍗 New Bucket Deal: Double the Chicken, Half the Price!',
      shortDescription: 'Massive savings on our most loaded chicken combo yet!',
      description:
          'You asked, we delivered! Introducing our most generous chicken bucket yet — perfect for families, parties, or solo indulgence.',
      imagePath: 'assets/images/chicken.jpg',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      contentBlocks: [
        NewsContent(type: ContentType.image, data: 'assets/images/chicken.jpg'),
        NewsContent(
          type: ContentType.text,
          data:
              'Say hello to the **Ultimate Chicken Bucket**! 12 pieces of golden crispy chicken, seasoned fries, 4 dips, and a 1.5L drink — all for just \$9.99!',
        ),
        NewsContent(type: ContentType.image, data: 'assets/images/chicken.jpg'),
        NewsContent(
          type: ContentType.text,
          data:
              'Available only for a limited time at all participating locations. Perfect for game nights, family dinners, or sharing with your squad.',
        ),
        NewsContent(type: ContentType.video, data: 'assets/videos/chicken_bucket_ad.mp4'),
        NewsContent(
          type: ContentType.text,
          data:
              'Watch our sizzling ad and hear from customers who tried the new bucket and can’t stop raving about it!',
        ),
      ],
    ),
    NewsModel(
      title: '🎁 Rooster Rewards: Eat More, Earn More!',
      shortDescription: 'Loyalty has never tasted this good — join today!',
      description:
          'Loyalty gets tasty! Sign up for Rooster Rewards and start earning points on every bite.',
      imagePath: 'assets/images/summer.jpg',
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      contentBlocks: [
        NewsContent(type: ContentType.image, data: 'assets/images/App_Update.png'),
        NewsContent(
          type: ContentType.text,
          data:
              'Introducing our new **Rooster Rewards** program! Every time you place an order — dine-in, takeaway, or online — you earn points.',
        ),
        NewsContent(type: ContentType.image, data: 'assets/images/no_image.jpg'),
        NewsContent(
          type: ContentType.text,
          data:
              'Use the ROOSTER app to track your points, unlock free meals, birthday gifts, and VIP access to new menu items. 🥳',
        ),
        NewsContent(type: ContentType.video, data: 'assets/videos/rewards_explainer.mp4'),
        NewsContent(
          type: ContentType.text,
          data:
              'Watch the video to see how easy it is to register and start earning today. Because loyal foodies deserve love!',
        ),
      ],
    ),
  ].obs;
}
