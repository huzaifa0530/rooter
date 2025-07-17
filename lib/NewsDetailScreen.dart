import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rooster/Models/NewsModel.dart';
import 'package:rooster/widgets/MainScaffold.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


          return MainScaffold(
      title: 'ROOSTER',
      currentIndex: null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🖼️ Header Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                news.imagePath,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 20),

            // 📰 Title
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            // 📅 Date Published
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat.yMMMMd().format(news.publishedAt),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🧾 Full Content
            Text(
              news.fullDescription,
              style: const TextStyle(fontSize: 16, height: 1.7),
            ),

            const SizedBox(height: 24),

            // 🔥 Highlight / tags (Optional)
            Wrap(
              spacing: 8,
              children: [
                _buildChip('ROOSTER Update', theme),
                _buildChip('Food Offers', theme),
                _buildChip('Branch News', theme),
              ],
            ),

            const SizedBox(height: 30),

            // 🎥 Sample Embedded Media Block (optional or replace with real video)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Watch the Experience',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/no_image.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Take a behind-the-scenes look at our newest branch with this exclusive video teaser!',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 🧠 Footer UX Tip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Text(
                    'Did you enjoy this update?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Share it with your friends or visit your nearest ROOSTER location today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    
    );
  }

  Widget _buildChip(String label, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border:
            Border.all(color: theme.primaryColor.withOpacity(0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department,
              size: 16, color: theme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
