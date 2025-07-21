import 'package:flutter/material.dart';
import 'package:rooster/Models/Handbook.dart';

class HandbookDetailScreen extends StatelessWidget {
  final Handbook handbook;
  const HandbookDetailScreen({super.key, required this.handbook});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('ROOSTER', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Main Thumbnail
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
                          child: const Icon(Icons.image_not_supported, size: 80),
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
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              handbook.description,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
            ),

            const SizedBox(height: 24),

            // 🔁 Dynamic Content Blocks
            ...handbook.contentBlocks.map((block) => _buildContentBlock(block)),

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
                      style: const TextStyle(color: Colors.black87, fontSize: 14),
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

  /// 🔁 Renders a content block (text, image, video placeholder)
  Widget _buildContentBlock(HandbookContent block) {
    switch (block.type) {
      case ContentType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            block.data,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        );

      case ContentType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              block.data,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );

      case ContentType.video:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_outline, size: 64, color: Colors.black45),
            ),
          ),
        );
    }
  }

  /// 🔖 Tag widget builder
  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
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
            style: const TextStyle(
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
