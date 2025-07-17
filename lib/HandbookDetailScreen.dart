import 'package:flutter/material.dart';
import 'package:rooster/Models/Handbook.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class HandbookDetailScreen extends StatelessWidget {
  final Handbook handbook;
  const HandbookDetailScreen({super.key, required this.handbook});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('ROOSTER',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: handbook.thumbnailUrl.startsWith('http')
                    ? Image.network(
                        handbook.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[100],
                          child:
                              const Icon(Icons.image_not_supported, size: 80),
                        ),
                      )
                    : Image.asset(
                        handbook.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // 🧾 Title & Description
            Text(
              handbook.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              handbook.description,
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
            ),

            const SizedBox(height: 16),

            // 🎥 Optional Video Preview Placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: Colors.black12,
                width: double.infinity,
                height: 180,
                child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.black45, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Watch video tutorial on how to apply these techniques for best results.',
              style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54),
            ),

            const SizedBox(height: 24),

            // 📖 Full Content
            Text(
              handbook.content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),

            const SizedBox(height: 24),

            // 📌 Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag('Fried Chicken', theme),
                _buildTag('Kitchen Safety', theme),
                _buildTag('Tips', theme),
                _buildTag('Recipe', theme),
              ],
            ),

            const SizedBox(height: 30),

            // 🧑‍🍳 Chef's Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_outlined,
                      color: Colors.orange, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Chef’s Tip: Always let your chicken rest for 5 minutes after frying to keep it juicy and crispy!',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      );
  }

  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08), // subtle background tint
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            tag,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
