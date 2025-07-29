import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/NewsModel.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});
Future<NewsModel> fetchNewsDetail() async {
  final String url = 'https://test.rubicstechnology.com/api/news/${news.id}'; // Replace with actual API URL

  try {
    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return NewsModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load news detail. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Fetch error: $e');  // ⬅️ See exact error
    rethrow;
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ROOSTER'),
        backgroundColor: theme.primaryColor,
      ),
      body: SafeArea(
        child: FutureBuilder<NewsModel>(
          future: fetchNewsDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Failed to load news'));
            }

            final updatedNews = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🖼️ Header Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network( // ✅ Use network image for dynamic content
                    updatedNews.imagePath,
                    fit: BoxFit.cover,
                    height: 220,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Image.asset('assets/images/no_image.jpg'),
                  ),
                ),
                const SizedBox(height: 20),

                // 📰 Title
                Text(
                  updatedNews.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 📝 Short description
                Text(
                  updatedNews.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // 📅 Date
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.yMMMMd().format(updatedNews.publishedAt),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🏷️ Tags/Chips
                Wrap(
                  spacing: 8,
                  children: updatedNews.tags.map((tag) => _buildChip(tag, theme)).toList(),
                ),

                const SizedBox(height: 24),

                // 📦 Content Blocks (Image/Video + description)
                ..._buildContentBlocks(updatedNews.contentBlocks),

                const SizedBox(height: 30),

                // 💡 Footer
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
            );
          },
        ),
      ),
    );
  }
List<Widget> _buildContentBlocks(List<NewsContent> blocks) {
  return blocks.map((block) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.type == ContentType.image) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                block.mediaPath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset('assets/images/no_image.jpg'),
              ),
            ),
            const SizedBox(height: 8),
          ] else if (block.type == ContentType.video) ...[
            const Text(
              '🎥 Video Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/no_image.jpg', // Replace with actual video thumbnail if available
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Video: ${block.mediaPath.split('/').last}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.description,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }).toList();
}


  Widget _buildChip(String label, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.primaryColor.withOpacity(0.6), width: 1),
        boxShadow: const [
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
          Icon(Icons.local_fire_department, size: 16, color: theme.primaryColor),
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
